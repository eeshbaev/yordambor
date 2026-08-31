# YordamBor — Onboarding System Design

Mobile-first · Guest-first · Trust through portfolio · UZ / RU / EN / ZH

---

## 1. Design philosophy

YordamBor onboarding is **not** a 10-slide tutorial. It is a **short path to the feed**, with signup only when the user wants to act.

| Principle | Meaning |
|-----------|---------|
| **Show, don’t explain** | First “wow” = a real portfolio card, not illustrations |
| **Guest first** | Browse Yordam Bor / Yordam Kerak without an account |
| **One account** | No “I’m a client” vs “I’m a provider” fork |
| **Signup on intent** | Account only when ♥, Yordam Bor, Yordam Kerak, or Profil action |
| **Verify before deal** | Email confirmed before first Kelishuv |
| **Offer services later** | “Xizmat ko‘rsatish” lives in Profil, never blocks entry |

**North star:** User opens app → understands YordamBor in **≤8 seconds** → sees services → acts when ready.

---

## 2. Onboarding map (full journey)

```
┌─────────────┐
│   SPLASH    │  1.2s — logo only
└──────┬──────┘
       ▼
┌─────────────┐     First install only
│  WELCOME    │  1 screen — tagline + 2 buttons
└──────┬──────┘
       ├──────────────────┐
       ▼                  ▼
┌─────────────┐    ┌─────────────┐
│    HOME     │    │  REGISTER   │  optional path
│  (guest)    │    └──────┬──────┘
└──────┬──────┘           ▼
       │            ┌─────────────┐
       │            │   VERIFY    │  email link
       │            └──────┬──────┘
       │                   ▼
       └──────────►  HOME (logged in)
                           │
              action needs auth ──► AUTH SHEET (login/register)
                           │
              Profil ──► "Xizmat ko‘rsatish?" (optional, anytime)
```

**Returning user (logged in):** Splash → Home (skip Welcome).

**Returning guest:** Splash → Home (skip Welcome after first visit).

---

## 3. Screen-by-screen

### 3.1 Splash (`SplashScreen`)

**When:** Every cold start.

**UI:**
- Full screen, brand teal gradient (subtle)
- `yordambor-logo.svg` centered
- No text, no buttons

**Duration:** 1.2s max, or until auth/session restored (whichever is first).

**Logic:**
```
if session valid → Home
else if first_install → Welcome
else → Home (guest)
```

---

### 3.2 Welcome (`WelcomeScreen`) — first install only

**UI:**

```
┌─────────────────────────────────┐
│                                 │
│         [ YordamBor logo ]      │
│                                 │
│     Yordam kerakmi?             │
│         YordamBor.              │
│                                 │
│  Ustalar va xizmatlarni         │
│  kashf qiling. Yordam bering    │
│  yoki yordam so‘rang.           │
│                                 │
│  ┌─────────────────────────┐  │
│  │      Boshlash           │  │  → Home (guest)
│  └─────────────────────────┘  │
│                                 │
│  ┌─────────────────────────┐  │
│  │   Hisob yaratish        │  │  → Register
│  └─────────────────────────┘  │
│                                 │
│  Allaqachon hisobingiz bormi?   │
│            Kirish               │  → Login
│                                 │
│  [ UZ ▾ ]                       │  bottom-left language
└─────────────────────────────────┘
```

**Copy variants (l10n):**

| Lang | Tagline |
|------|---------|
| UZ | Yordam kerakmi? YordamBor. |
| RU | Нужна помощь? YordamBor. |
| EN | Need help? YordamBor. |
| ZH | 需要帮助？YordamBor。 |

**Rules:**
- Never show again after “Boshlash” or successful login (flag: `onboarding_welcome_seen`)
- **No carousel** — one screen only
- Language picker persists to Sozlamalar + app locale

---

### 3.3 Home as onboarding (the real hook)

Empty feed is onboarding failure. Mitigations:

| State | UI |
|-------|-----|
| **Feed has cards** | User scrolls portfolio cards — onboarding = product |
| **Feed empty (v1 launch)** | Hero card + 3 **seeded demo xizmatlar** (marked “Demo” in dev) + CTA: “Siz ham xizmat qo‘shing” |
| **First scroll hint** | One-time subtle overlay: “Yuqoriga-pastga — xizmatlarni ko‘ring” (dismiss on scroll) |

**First-time tooltips (max 3, once ever):**

1. **Filter chip** — “Yordam Bor yoki Yordam Kerak tanlang”
2. **♥ on card** — “Sevimlilarga saqlash” → triggers auth sheet if guest
3. **Profil tab** — “Hisob va xizmatlaringiz”

Tooltips: small coach marks, not blocking modals.

---

### 3.4 Auth sheet (`AuthBottomSheet`) — signup on intent

**Triggers:**
- Tap ♥ (favorite)
- Tap **Yordam Kerak** on card
- Tap **Yordam Bor** / respond to post
- FAB **E’lon qoldirish**
- Profil → Kirish / Ro‘yxatdan o‘tish
- Any Kelishuv action

**UI:** Modal bottom sheet (~85% height), swipe to dismiss.

```
┌─────────────────────────────────┐
│  ───                            │
│                                 │
│  Davom etish uchun kiring        │
│  (context: "Saqlash uchun…")     │
│                                 │
│  [ Tab: Kirish | Ro'yxat ]       │
│                                 │
│  … fields …                      │
│                                 │
│  [ Davom etish ]                 │
│                                 │
│  Keyinroq                        │  dismiss → guest
└─────────────────────────────────┘
```

**Contextual subtitle examples:**

| Action | Subtitle |
|--------|----------|
| Favorite | Saqlash uchun ro‘yxatdan o‘ting |
| Yordam Kerak | Ustaga so‘rov yuborish uchun |
| Yordam Bor | Taklif yuborish uchun |
| Post job | E’lon qoldirish uchun |

---

### 3.5 Register (`RegisterForm`)

**Single screen — no wizard.**

| Field | Required | Validation |
|-------|----------|------------|
| To‘liq ism | Yes | min 2 chars |
| Email | Yes | valid email, unique |
| Telefon | Yes | +998… format, unique |
| Parol | Yes | min 8 chars |
| Parol takror | Yes | match |
| ☐ Foydalanish shartlari | Yes | link to terms |

**On submit:**
1. Supabase `signUp` with email + password
2. Store phone + full_name in `profiles` (trigger or upsert)
3. → **Verify Email** screen (not Home yet for deal actions)

**Error copy:**
- Email exists → “Bu email bilan hisob mavjud. Kirishni sinab ko‘ring.”
- Phone exists → same pattern

---

### 3.6 Login (`LoginForm`)

| Field | Rule |
|-------|------|
| Email **or** telefon | one identifier field (smart detect) |
| Parol | required |

Links: **Parolni unutdingizmi?** → Supabase reset email.

On success → Home, dismiss sheet.

---

### 3.7 Verify email (`VerifyEmailScreen`)

**When:** After register, or logged in but `emailConfirmedAt == null` and user tries Kelishuv/favorite/post.

```
┌─────────────────────────────────┐
│  ✉️                              │
│                                 │
│  Emailni tasdiqlang              │
│                                 │
│  {email} manziliga havola         │
│  yubordik.                       │
│                                 │
│  [ Pochtani ochish ]             │
│  [ Qayta yuborish ]  (60s cooldown) │
│                                 │
│  Ko‘rib chiqishni davom eting     │  → Home (browse only)
└─────────────────────────────────┘
```

**Gated until verified:**
- Favorites persist
- Yordam Bor / Yordam Kerak / Kelishuv
- E’lon qoldirish

**Allowed unverified:**
- Browse feeds
- View xizmat profiles
- Sozlamalar (except delete needs confirm)

---

### 3.8 Post-auth soft prompt — NOT onboarding blocker

**When:** First login, once (optional card on Profil):

```
┌─────────────────────────────────┐
│  Xizmat ko‘rsatasizmi?           │
│  Portfolio qo‘shing — mijozlar    │
│  sizni topadi.                    │
│                                 │
│  [ Xizmat yaratish ]  [ Keyin ] │
└─────────────────────────────────┘
```

**Never on Welcome.** Never forced. Max once per account.

---

### 3.9 Provider mini-onboarding (`CreateXizmatFlow`) — separate from app onboarding

Triggered from Profil → **Xizmat ko‘rsatish** or soft prompt.

**3 steps (not 10):**

```
Step 1 — Kim siz?
  ○ Mutaxassis (jismoniy)
  ○ Tashkilot
  Soha → Subsoha
  Xizmat nomi

Step 2 — Ishingiz
  Kamida 1 portfolio rasm (majburiy)
  Qisqa tavsif
  Avatar

Step 3 — Tayyor
  “Xizmatingiz Discover’da ko‘rinadi”
  [ Asosiyga o‘tish ]
```

Gate: no photo = not in Yordam Bor feed (matches product rule).

---

## 4. What we deliberately exclude

| Excluded | Why |
|----------|-----|
| 5-slide feature carousel | Users skip; feed teaches better |
| Pick 10 interests | Filters on Home enough |
| Phone OTP at signup | Email verify + password (locked spec) |
| “Are you client or provider?” | One account |
| Location permission upfront | No location system v1 |
| Notification permission on day 0 | Ask after first Kelishuv or Eslatma setup |
| Facebook/Google login v1 | Add v1.1 if needed |

---

## 5. Notification & permissions timing

| Permission | When to ask |
|------------|-------------|
| **Notifications** | After first Kelishuv accepted, or entering Eslatmalar |
| **Photos** | When uploading portfolio (Step 2 xizmat) |
| **Camera** | Optional, same moment |

Use pre-prompt sheet: “YordamBor sizga kelishuvlar haqida xabar beradi” → system dialog.

---

## 6. Visual & motion language

| Element | Spec |
|---------|------|
| **Primary CTA** | Filled teal, full width, 52px height |
| **Secondary** | Outlined |
| **Splash → Welcome** | Fade + slight scale logo (300ms) |
| **Welcome → Home** | Shared axis horizontal slide |
| **Auth sheet** | Slide up, spring curve |
| **Success** | Subtle checkmark haptic + “Xush kelibsiz, {ism}!” snackbar |

**Tone:** Warm, direct Uzbek-first copy. Short sentences. No corporate jargon.

---

## 7. State machine (implementation reference)

```dart
enum OnboardingGate {
  splash,
  welcome,           // first install
  homeGuest,
  homeAuthenticated,
  verifyEmailPending,
}

enum AuthRequirement {
  none,              // browse
  account,           // login/register
  verifiedEmail,     // Kelishuv, favorites, post
}
```

**Action → required gate:**

| Action | Gate |
|--------|------|
| View feed / profile | none |
| Favorite | account + verifiedEmail |
| Yordam Bor / Kerak | account + verifiedEmail |
| Create xizmat | account + verifiedEmail |

---

## 8. Persistence (local)

| Key | Type | Purpose |
|-----|------|---------|
| `welcome_seen` | bool | Skip Welcome |
| `tooltip_filters_seen` | bool | Coach marks |
| `tooltip_favorite_seen` | bool | |
| `tooltip_profile_seen` | bool | |
| `provider_prompt_dismissed` | bool | Soft xizmat CTA |

Store in `shared_preferences` or Hive.

---

## 9. Analytics events (onboarding funnel)

| Event | When |
|-------|------|
| `onboarding_welcome_view` | Welcome shown |
| `onboarding_guest_start` | Boshlash tapped |
| `onboarding_register_start` | Register tab |
| `onboarding_register_complete` | Signup success |
| `onboarding_verify_complete` | Email confirmed |
| `onboarding_login_complete` | Login success |
| `onboarding_provider_prompt_shown` | Soft CTA |
| `onboarding_xizmat_created` | First xizmat |

---

## 10. Copy deck (UZ primary)

### Welcome
- **Title:** Yordam kerakmi?
- **Subtitle:** YordamBor.
- **Body:** Ustalar va xizmatlarni kashf qiling. Yordam bering yoki yordam so‘rang.
- **Primary:** Boshlash
- **Secondary:** Hisob yaratish
- **Link:** Allaqachon hisobingiz bormi? Kirish

### Auth sheet titles
- Generic: Davom etish uchun kiring
- Favorite: Sevimlilarga saqlash uchun kiring
- Deal: Kelishuv boshlash uchun kiring

### Verify
- Title: Emailni tasdiqlang
- Body: {email} manziliga tasdiqlash havolasi yubordik.

### Provider prompt
- Title: Xizmat ko‘rsatasizmi?
- Body: Portfolio qo‘shing — mijozlar sizni Discover’da topadi.

---

## 11. Implementation phases

| Sprint | Deliverable |
|--------|-------------|
| **1a** | Splash, Welcome, auth sheet, login/register, verify email, gates |
| **1b** | Contextual auth subtitles, forgot password |
| **2a** | Coach mark tooltips, empty feed seed cards |
| **2b** | CreateXizmat 3-step flow + provider prompt |
| **Pre-launch** | Motion polish, 4-language copy, notification pre-prompt |

---

## 12. Success metrics

| Metric | Target (v1) |
|--------|-------------|
| Welcome → Boshlash (guest) | >60% |
| Welcome → Register start | >15% |
| Register → Verify complete | >70% |
| D1 return (guest) | >30% |
| D1 return (registered) | >50% |
| Time to first feed view | <5s from cold start |

---

*Aligned with YordamBor v1 product spec · August 2026*
