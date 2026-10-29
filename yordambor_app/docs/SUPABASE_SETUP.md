# Supabase setup checklist

Project: `ashlfdfotymwalfykicv`  
App env: `yordambor_app/.env.json` (not committed to git)

## 1. Dashboard — Authentication → URL Configuration

| Field | Value |
|-------|--------|
| **Site URL** | `yordambor://auth/callback` |
| **Redirect URLs** | `yordambor://auth/callback` |

**Common mistake:** `yordanbor://` (with **n**) is wrong — must be **`yordambor://`** (with **m**).

Delete wrong entries like `yordanbor://auth/callback` and `http://localhost:3000` unless you use a local web app.

## 2. Dashboard — Authentication → Providers

- **Email** enabled
- For testing: disable **Confirm email** (optional)
- For production: keep confirm email on

## 3. Run the app with env loaded

```bash
cd yordambor_app
./tool/run_dev.sh
```

Do **not** run plain `flutter run` without `--dart-define-from-file=.env.json`.

## 4. Run SQL migrations

In Supabase Dashboard → **SQL Editor**, run migrations from  
`yordambor_app/supabase/migrations/` in order (001, 002, …).

**018** adds sub-sector alert subscriptions and DB triggers (new services, price drops, Yordam kerak posts). Required for **Bildirishnomalar → Subsoha bildirishnomalari**.

If you see “already exists” on re-run, that is usually safe to ignore.

## 5. Android emulator DNS errors

If logs show:

```
Failed host lookup: '....supabase.co'
```

The emulator cannot reach the internet DNS. Fixes:

1. **Cold boot** the AVD (Device Manager → ⋮ → Cold Boot Now)
2. Test on a **real phone** on Wi‑Fi
3. Emulator **Settings → Network** — ensure Wi‑Fi is connected
4. Sign out in the app if you were logged in before (clears stale token)

The app now signs out locally when refresh fails offline, so demo mode still works.

## 6. Play Store / release builds

Pass the same keys at build time:

```bash
flutter build appbundle --release --dart-define-from-file=.env.json
```

Or set GitHub Actions secrets `SUPABASE_URL` and `SUPABASE_ANON_KEY`.

## 7. Verify connection

1. `./tool/run_dev.sh` on a real device
2. Sign up or sign in with email
3. Create a xizmat listing — it should appear after refresh (not only demo)
