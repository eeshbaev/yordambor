/**
 * Supabase Edge Function: telegram-auth
 *
 * Handles the Telegram Login Widget flow for a Flutter mobile app:
 *
 * GET  /telegram-auth
 *   → Returns an HTML page with the Telegram Login Widget.
 *     The widget redirects back to this same function with Telegram
 *     auth params when the user approves.
 *
 * GET  /telegram-auth?id=...&first_name=...&hash=...&...
 *   → Verifies HMAC-SHA256 hash, upserts Supabase user via Admin API,
 *     creates a session, and redirects to the app deep link
 *     `yordambor://auth/callback#access_token=...&refresh_token=...`
 *
 * Required secrets (set via `supabase secrets set`):
 *   TELEGRAM_BOT_TOKEN   – bot token from @BotFather (not shown in client)
 *   SUPABASE_SERVICE_ROLE_KEY – already available as built-in Supabase secret
 */

import { createClient } from 'https://esm.sh/@supabase/supabase-js@2';

const SUPABASE_URL = Deno.env.get('SUPABASE_URL')!;
const SERVICE_ROLE_KEY = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!;
const BOT_TOKEN = Deno.env.get('TELEGRAM_BOT_TOKEN')!;

// The deep-link scheme registered in AndroidManifest / Info.plist.
const APP_CALLBACK = 'yordambor://auth/callback';

// ──────────────────────────────────────────────────────────────────
// Telegram HMAC verification (https://core.telegram.org/widgets/login)
// data_check_string = sorted key=value pairs (except 'hash'), joined by \n
// secret           = SHA-256 of the bot token
// expected_hash    = HMAC-SHA256(secret, data_check_string) as hex
// ──────────────────────────────────────────────────────────────────
async function verifyTelegramHash(params: URLSearchParams): Promise<boolean> {
  const receivedHash = params.get('hash');
  if (!receivedHash) return false;

  // Build the data-check string (all params except hash, sorted).
  const entries: string[] = [];
  for (const [key, value] of params.entries()) {
    if (key !== 'hash') entries.push(`${key}=${value}`);
  }
  entries.sort();
  const dataCheckString = entries.join('\n');

  // Secret key = SHA-256(bot token).
  const botTokenBytes = new TextEncoder().encode(BOT_TOKEN);
  const secretKey = await crypto.subtle.digest('SHA-256', botTokenBytes);

  // HMAC-SHA256 of data-check string using the secret key.
  const dataBytes = new TextEncoder().encode(dataCheckString);
  const computedKey = await crypto.subtle.importKey(
    'raw', secretKey, { name: 'HMAC', hash: 'SHA-256' }, false, ['sign'],
  );
  const signatureBuffer = await crypto.subtle.sign('HMAC', computedKey, dataBytes);
  const computedHash = Array.from(new Uint8Array(signatureBuffer))
    .map(b => b.toString(16).padStart(2, '0'))
    .join('');

  return computedHash === receivedHash;
}

// ──────────────────────────────────────────────────────────────────
// HTML page served to the user (contains the Telegram Login Widget).
// After the user approves, Telegram redirects back to this function
// URL with the auth params appended as query string.
// ──────────────────────────────────────────────────────────────────
function loginPageHtml(functionUrl: string): string {
  return `<!doctype html>
<html lang="uz">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<title>YordamBor — Telegram bilan kirish</title>
<style>
  body{margin:0;min-height:100vh;display:flex;flex-direction:column;
       align-items:center;justify-content:center;font-family:system-ui,sans-serif;
       background:#F4F4F4;gap:24px;}
  .card{background:#fff;border-radius:20px;padding:40px 32px;
        box-shadow:0 4px 24px rgba(0,0,0,.08);text-align:center;max-width:340px;width:90%;}
  h1{margin:0 0 6px;font-size:22px;font-weight:700;color:#212121;}
  p{margin:0 0 28px;font-size:14px;color:#9E9E9E;}
</style>
</head>
<body>
<div class="card">
  <h1>YordamBor</h1>
  <p>Telegram hisobingiz bilan davom eting</p>
  <script async
    src="https://telegram.org/js/telegram-widget.js?22"
    data-telegram-login="Your_YordamBor_bot"
    data-size="large"
    data-radius="10"
    data-auth-url="${functionUrl}"
    data-request-access="write">
  </script>
</div>
</body>
</html>`;
}

// ──────────────────────────────────────────────────────────────────
// Handler
// ──────────────────────────────────────────────────────────────────
Deno.serve(async (req: Request) => {
  const url = new URL(req.url);
  const params = url.searchParams;

  // No Telegram params → show the login page.
  if (!params.has('id') || !params.has('hash')) {
    return new Response(loginPageHtml(req.url), {
      headers: { 'Content-Type': 'text/html; charset=utf-8' },
    });
  }

  // ── Verify HMAC ─────────────────────────────────────────────────
  const valid = await verifyTelegramHash(params);
  if (!valid) {
    return new Response('Telegram auth tekshiruvi muvaffaqiyatsiz', { status: 403 });
  }

  // ── Auth data from Telegram ──────────────────────────────────────
  const telegramId  = params.get('id')!;
  const firstName   = params.get('first_name') ?? '';
  const lastName    = params.get('last_name') ?? '';
  const photoUrl    = params.get('photo_url') ?? null;
  const authDateStr = params.get('auth_date') ?? '0';
  const authDate    = parseInt(authDateStr, 10);

  // Reject tokens older than 1 day.
  const nowSec = Math.floor(Date.now() / 1000);
  if (nowSec - authDate > 86400) {
    return new Response('Telegram auth muddati tugagan', { status: 403 });
  }

  const fullName = [firstName, lastName].filter(Boolean).join(' ').trim();

  // ── Upsert via Admin API ─────────────────────────────────────────
  const admin = createClient(SUPABASE_URL, SERVICE_ROLE_KEY, {
    auth: { autoRefreshToken: false, persistSession: false },
  });

  // Synthetic stable email so Supabase auth always has one.
  const syntheticEmail = `tg_${telegramId}@telegram.yordambor.app`;

  // Try to find an existing user with this synthetic email.
  const { data: existingList } = await admin.auth.admin.listUsers();
  const existing = existingList?.users?.find(u => u.email === syntheticEmail);

  let userId: string;

  if (existing) {
    userId = existing.id;
    // Keep their name up to date (in case they changed it in Telegram).
    if (fullName && existing.user_metadata?.full_name !== fullName) {
      await admin.auth.admin.updateUserById(userId, {
        user_metadata: { ...existing.user_metadata, full_name: fullName },
      });
    }
  } else {
    // Create a new confirmed user.
    const { data: created, error: createErr } = await admin.auth.admin.createUser({
      email: syntheticEmail,
      email_confirm: true,
      user_metadata: {
        full_name: fullName,
        avatar_url: photoUrl,
        provider: 'telegram',
        telegram_id: telegramId,
      },
    });
    if (createErr || !created?.user) {
      console.error('createUser error', createErr);
      return new Response("Foydalanuvchi yaratib bo'lmadi", { status: 500 });
    }
    userId = created.user.id;
  }

  // ── Create a short-lived session link ───────────────────────────
  // generate_link returns a one-time magic link; we redirect there
  // so Supabase sets the session cookie/tokens automatically, then
  // our redirect_to deep-link fires and returns us to the app.
  const { data: linkData, error: linkErr } =
    await admin.auth.admin.generateLink({
      type: 'magiclink',
      email: syntheticEmail,
      options: {
        redirectTo: APP_CALLBACK,
      },
    });

  if (linkErr || !linkData?.properties?.action_link) {
    console.error('generateLink error', linkErr);
    return new Response("Session yaratib bo'lmadi", { status: 500 });
  }

  // Redirect the browser to the Supabase magic link; Supabase exchanges
  // it for tokens and then redirects to yordambor://auth/callback.
  return Response.redirect(linkData.properties.action_link, 302);
});
