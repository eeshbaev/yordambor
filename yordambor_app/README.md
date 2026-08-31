# YordamBor App

Flutter mobile app for iOS and Android.

## Prerequisites

- Flutter 3.x ([install](https://docs.flutter.dev/get-started/install))
- Supabase project ([supabase.com](https://supabase.com))

## Setup

### 1. Supabase

Run migrations in order in the Supabase SQL editor:

1. `supabase/migrations/001_initial.sql`
2. `supabase/migrations/002_rls.sql`
3. `supabase/migrations/003_seed_categories.sql`

Create a Storage bucket named `portfolio` (public read, authenticated write).

### 2. Run the app

```bash
cd yordambor_app
flutter pub get
flutter run \
  --dart-define=SUPABASE_URL=https://YOUR_PROJECT.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=YOUR_ANON_KEY
```

Without Supabase keys the app still runs (local UI only).

## Sprint status

### Sprint 0 ✅
- Bottom nav shell (Asosiy · Saqlangan · Profil)
- Home filter bar (Yordam Bor / Yordam Kerak)
- Supabase schema + category seed SQL

### Sprint 1a ✅ Onboarding & auth
- Splash → Welcome (first install) → Home (guest)
- Auth bottom sheet (login / register / forgot password)
- Email verification screen
- Auth gates on FAB post, profile actions
- 4-language welcome copy (UZ / RU / EN / ZH)
- Provider soft prompt on Profil

See [../docs/ONBOARDING_DESIGN.md](../docs/ONBOARDING_DESIGN.md) for UX spec.

### Sprint 2 — Xizmat & feeds ✅ (core)
- Supabase xizmat feed (demo fallback when empty)
- Create Xizmat 3-step flow + portfolio upload
- Soha / Subsoha taxonomy picker
- Xizmat profile with portfolio gallery
- Favorites sync to Supabase (UUID xizmatlar)
- Run migration `004_storage.sql` + create `portfolio` bucket

### Next (Sprint 3)
- [ ] Kelishuv / Taklif engine
- [ ] Yordam Kerak posts CRUD

## Project structure

```
lib/
├── main.dart
├── app.dart
├── core/           # config, theme, router, l10n
├── application/    # Riverpod providers
├── domain/         # entities (Sprint 1+)
├── data/           # Supabase repos (Sprint 1+)
└── presentation/   # screens & widgets
```

See [../docs/IMPLEMENTATION_PLAN.md](../docs/IMPLEMENTATION_PLAN.md) for the full roadmap.
