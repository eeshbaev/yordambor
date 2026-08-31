# YordamBor — Code Audit Report

**Date:** August 30, 2026
**Scope:** `yordambor_app/` (Flutter/Riverpod/Supabase codebase, ~180 Dart files)
**Method:** Direct inspection of source on your machine (structure, dependencies, config, targeted static analysis via grep). See "Method note" at the end — this is not a substitute for `flutter analyze`.

## Overview

This is a genuinely well-built prototype — far more complete than the docs in `/docs` suggest ("Sprint 0 started"). It has clean architecture (domain/data/application/presentation), 180+ files, working Kelishuv negotiation engine, 4-language localization, a real design system, and 8 test files. No hardcoded secrets, no leftover `print()` debugging, no TODO/FIXME litter, no empty catch blocks, no deprecated Flutter APIs. That's a genuinely clean baseline — most Cursor-built prototypes are messier than this.

Three issues below are **critical** — one will crash the app on iOS, one is an unmanaged business risk (no version control), and one undermines the core trust proposition of the product (fake listings mixed permanently into the real feed). Everything else is fixable in hours, not days.

| # | Issue | Severity |
|---|-------|----------|
| 1 | No version control (no git repo) | Critical |
| 2 | iOS crashes on photo/camera access — missing Info.plist permissions | Critical |
| 3 | Demo/fake listings are permanent and indistinguishable from real ones | Critical |
| 4 | `TextEditingController` leaks in 9 files | Medium |
| 5 | Unguarded Supabase `.single()` calls (7 sites) | Medium |
| 6 | Pre-release dependency pinned (`freezed ^4.0.0-dev.3`) | Medium |
| 7 | Chinese (zh) localization incomplete | Medium |
| 8 | Zero test coverage on the Kelishuv negotiation engine | Medium |

---

## 1. CRITICAL — No version control

**Finding:** `yordambor_app/` (and the parent `YordamBor/` folder) is not a git repository at all — there's no `.git` anywhere.

**Why this matters:** Every edit Cursor or you make overwrites the previous version with no history, no rollback, no diff, no backup. One bad AI-assisted edit, one accidental delete, one corrupted save — and there is no way back. This is the single highest-leverage fix on this list: it costs five minutes and protects everything else.

**Fix:**
```bash
cd "yordambor_app"
git init
git add .
git commit -m "Initial commit — baseline before audit fixes"
```
Then create a private GitHub/GitLab repo and push, so you have an off-machine backup too:
```bash
git remote add origin <your-repo-url>
git branch -M main
git push -u origin main
```
Your `.gitignore` already correctly excludes `.env.json`, `build/`, `.dart_tool/` — verified, no changes needed there.

---

## 2. CRITICAL — iOS will crash when picking a photo

**Finding:** `ios/Runner/Info.plist` has **no privacy usage description keys** — no `NSPhotoLibraryUsageDescription`, no `NSCameraUsageDescription`. But `image_picker` is used in 5 places:
- `lib/presentation/xizmat/create_xizmat_screen.dart` (portfolio photos)
- `lib/presentation/xizmat/manage_xizmat_screen.dart`
- `lib/presentation/profile/widgets/profile_certificates_section.dart`
- `lib/presentation/profile/widgets/profile_avatar.dart`
- `lib/presentation/client_book/widgets/appointment_detail_sheet.dart`

**Why this matters:** iOS hard-terminates any app that touches the photo library or camera without declaring why, in the Info.plist. This isn't a maybe — the **first time** a real user tries to upload a portfolio photo, set an avatar, or attach a certificate on iOS, the app will crash outright. This also blocks App Store submission — Apple's review explicitly checks for this.

**Fix:** Add these keys to `ios/Runner/Info.plist`, inside the outer `<dict>`:
```xml
<key>NSPhotoLibraryUsageDescription</key>
<string>YordamBor needs access to your photos so you can add portfolio images, a profile photo, or certificates.</string>
<key>NSCameraUsageDescription</key>
<string>YordamBor needs camera access so you can take a photo for your portfolio, profile, or certificates.</string>
```
(Add `NSPhotoLibraryAddUsageDescription` too if any flow *saves* images back to the library, not just reads them — worth a quick check of `appointment_detail_sheet.dart`.)

---

## 3. CRITICAL — Fake listings are permanent and unmarked

**Finding:** `lib/data/demo/` contains a large hand-built dataset — 40+ fake service providers (`demo_xizmat_feed.dart`), 90+ fake user profiles (`demo_user_profiles.dart`), 25+ fake job posts (`demo_yordam_kerak_feed.dart`) — complete with fabricated names, ratings ("4.9"), and completed-job counts ("23", "41").

The data model already has an `isDemo` flag on every entity (`XizmatFeedItem`, `YordamKerakPost`, `PublicUserProfile`) — good instinct. But tracing every usage of `isDemo` across the app (`grep -rn "isDemo" lib/`) shows it is used **exactly once** for actual behavior — blocking demo certificates from deletion in `certificate_repository.dart:96`. Everywhere else it's just passed through data mapping and never read.

Specifically, in `lib/data/demo/demo_feed_support.dart`:
```dart
static List<T> composePinned<T>({...}) {
  ...
  for (final item in realItems) {
    final id = idOf(item);
    // Bundled demos always win — Supabase must not override demo-* listings.
    if (id.startsWith('demo-')) continue;
    add(item);
  }
  for (final item in demoItems) {
    add(item);   // demo items always appended, forever, never removed
  }
  ...
}
```
This runs on **every** feed load in `feed_provider.dart` and `yordam_kerak_provider.dart` — not just when the real feed is empty. Demo and real listings are permanently interleaved.

And nothing in the presentation layer checks `isDemo`:
- `yb_xizmat_card.dart` (the card widget users see) has zero `isDemo` handling — no "Namuna" (sample) badge, nothing visually distinguishing a fake listing from a real one.
- `xizmat_profile_screen.dart`'s "send offer" button (`openTaklifFlow(... target: TaklifTarget.xizmat(xizmatId: itemId) ...)`) is not gated by `isDemo` at all.

**Why this matters:** A real user browsing your feed cannot tell "Sanjar the plumber, 4.9★, 23 jobs done" is fictional. If they tap through and try to send an offer, `itemId` is a string like `'demo-sanjar-plumber'` that doesn't exist in your Supabase `xizmatlar` table — the insert will fail (foreign key violation), and the user hits an error trying to contact your best-looking "provider." (Good news: `taklif_sheet.dart` does wrap this in `try/catch` with a `KelishuvFailure` handler, so it won't crash — but it will confuse and disappoint exactly the user you most wanted to convert.) This is precisely the kind of thing that destroys first-time trust in a marketplace, and depending on how it's presented, showing fabricated ratings and completed-job counts as if real is also a legal/trust liability worth taking seriously, not just a UX nit.

**Fix — pick one:**
- **Recommended for a real launch:** Stop shipping fake listings as if real. Either remove `demoItems` from `composePinned` entirely once you have your first ~20 real providers, or gate demo data behind a clearly-different visual treatment: a "Namuna" ribbon on the card (check `isDemo` in `yb_xizmat_card.dart`), disable/relabel the CTA to something like "Bu namuna — real providers coming soon," and never route demo items into `openTaklifFlow`.
- **If you want to keep demo listings during early cold-start** (a reasonable growth tactic many marketplaces use): make it structurally impossible to contact one. In `xizmat_profile_screen.dart`, check `item.isDemo` before enabling the offer button; in `yb_xizmat_card.dart`, render a small badge when `isDemo == true`. This is a ~1-hour fix given the flag already exists everywhere in the domain layer — the plumbing is done, it's just not wired to the UI.

---

## 4. MEDIUM — TextEditingController leaks

**Finding:** 56 `TextEditingController` declarations across the app, but 9 files declare one with **no `.dispose()` call anywhere in the file**:
```
lib/presentation/shared/xizmat_pricing_section.dart
lib/presentation/shared/xizmat_service_city_field.dart
lib/presentation/shared/xizmat_promise_section.dart
lib/presentation/shared/post_contact_preferences_section.dart
lib/presentation/earnings/earnings_screen.dart
lib/presentation/client_book/widgets/client_registry_sheet.dart
lib/presentation/client_book/widgets/client_booking_sheet.dart
lib/presentation/reminders/widgets/reminder_status_actions.dart
lib/presentation/reminders/widgets/reminder_add_sheet.dart
```
Confirmed real (not a false positive) in at least two: `earnings_screen.dart` creates `amountController`/`noteController` inside what is a `ConsumerWidget` (stateless) — likely inside a dialog-builder function, not a `State` object, so there's no `dispose()` lifecycle hook at all. Same pattern in `reminder_add_sheet.dart`, which isn't even a widget class — it's a function that presumably calls `showModalBottomSheet` with locally-scoped controllers that are never released.

**Why this matters:** Each time a user opens the earnings edit dialog or the "add reminder" sheet, a new controller is allocated and never freed. Individually tiny, but this is exactly the kind of leak that shows up as slow memory growth over a long session — worth fixing before you're debugging a vague "app gets sluggish after a while" report from a real user.

**Fix:** Wrap the controllers in a small `StatefulWidget` (or `StatefulBuilder` if it's a one-off dialog) and dispose them in `dispose()`:
```dart
class _AmountEditDialog extends StatefulWidget {
  @override
  State<_AmountEditDialog> createState() => _AmountEditDialogState();
}
class _AmountEditDialogState extends State<_AmountEditDialog> {
  late final _amountController = TextEditingController();
  late final _noteController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }
  ...
}
```
If refactoring to a StatefulWidget is too heavy for a one-off sheet, at minimum dispose manually after the sheet/dialog closes:
```dart
final result = await showModalBottomSheet(...);
nameController.dispose();
noteController.dispose();
serviceController.dispose();
```

---

## 5. MEDIUM — Unguarded Supabase `.single()` calls

**Finding:** 7 call sites use PostgREST's `.single()`, which throws a `PostgrestException` if the query returns 0 or 2+ rows:
```
lib/data/kelishuv/kelishuv_repository.dart:63   (insert...select().single())
lib/data/kelishuv/kelishuv_repository.dart:127  (insert...select().single())
lib/data/kelishuv/kelishuv_repository.dart:599
lib/data/yordam_kerak/yordam_kerak_repository.dart:185
lib/data/xizmat/xizmat_repository.dart:716      (insert...select().single())
lib/data/profile/certificate_repository.dart:69 (insert...select().single())
lib/data/review/review_repository.dart:108      (insert...select().single())
```
Most are `insert(...).select('id').single()` right after a write, which is low-risk (you just inserted the row). The two reads at `kelishuv_repository.dart:599` and `yordam_kerak_repository.dart:185` are riskier — if the referenced row was deleted or blocked between the list view and the detail fetch, `.single()` throws instead of returning a clean "not found."

**Fix:** For the two read sites, switch to `.maybeSingle()` and handle `null` explicitly:
```dart
final row = await supabase.from('kelishuv_messages').select('''...''').maybeSingle();
if (row == null) {
  throw KelishuvFailure('This message is no longer available.');
}
```
For the insert sites, no change needed — but worth a quick manual test (delete a xizmat mid-flow, confirm the resulting error surfaces a friendly message rather than a raw exception).

---

## 6. MEDIUM — Pre-release dependency in production

**Finding:** `pubspec.yaml`:
```yaml
freezed: ^4.0.0-dev.3
```
This pins a **dev/pre-release** version of `freezed` (used for your immutable model classes). Pre-release versions can introduce breaking changes between patch releases and aren't meant for production use.

**Fix:** Check what the current stable release is (`flutter pub outdated` on your machine, or check pub.dev directly) and pin to that instead, e.g.:
```yaml
freezed: ^2.5.7   # (check pub.dev for the actual current stable — this is illustrative)
```
Then run `flutter pub get` and `dart run build_runner build --delete-conflicting-outputs` to regenerate.

---

## 7. MEDIUM — Chinese localization incomplete

**Finding:** Comparing translation keys across the 4 ARB files:
```
lib/l10n/app_en.arb : 1726 lines generated
lib/l10n/app_ru.arb : 1719 lines generated
lib/l10n/app_uz.arb : 1738 lines generated
lib/l10n/app_zh.arb : 1666 lines generated  ← noticeably shorter
```
Diffing keys directly: 12 keys present in `app_en.arb` are absent from `app_zh.arb` (`currency`, `date`, `days`, `emailAddress`, `jobs`, `minutes`, `names`, `rate`, `rating`, `slot`, `tier`, `title`).

**Why this matters:** Your build plan calls out "Full UZ/RU/EN/ZH strings" as a v1 success criterion. Missing keys in the generated `AppLocalizations` class either fail codegen or silently fall back — worth confirming which before you consider Chinese "done."

**Fix:** Run the localization generator and read the warnings:
```bash
flutter gen-l10n
```
Then manually diff `app_en.arb` against `app_zh.arb` for the 12 keys listed above and fill in the missing translations.

---

## 8. MEDIUM — No test coverage on the Kelishuv negotiation engine

**Finding:** 8 test files, 435 lines total — covering deep links, feed filters, sharing, repeat-booking, and the provider-tier/growth logic reasonably well. But there is **no test coverage** for:
- `kelishuv_repository.dart` (the deal lifecycle: muzokarada → jarayonda → bajarildi, dual-accept, edit-resets-accept, archive/delete timers)
- `auth_repository.dart`
- Any repository's Supabase query logic

**Why this matters:** Your own build plan calls the Kelishuv engine the most rules-heavy part of the product (§2 "Key rules" lists 10+ interacting state-transition rules). That's exactly the code most worth protecting with tests before you keep extending it — a silent regression here (e.g., an edit that should reset both accepts but doesn't) directly breaks the core trust mechanic of the app.

**Fix:** Not urgent enough to block anything, but next time you touch `kelishuv_repository.dart` or the taklif/accept flow, add a unit test alongside the change. Prioritize: dual-accept-resets-on-edit, and the day-3 Jarayonda lock (both are easy to silently break and hard to notice in manual testing).

---

## What's already good (no action needed)

- **No hardcoded secrets.** `Env.supabaseUrl`/`Env.supabaseAnonKey` are read via `String.fromEnvironment` with `--dart-define`, `.env.json` is gitignored, and the Supabase anon key (safe to expose client-side by design, protected by RLS) isn't leaked anywhere unexpected.
- **No debug litter.** Zero `print()` statements, zero TODO/FIXME/HACK comments, zero empty catch blocks anywhere in `lib/`.
- **No deprecated APIs.** No `WillPopScope`, no `withOpacity`, no `http://` URLs.
- **The provider tier system** (`newProvider → active → trusted → top`, based on completed jobs + rating) is a tasteful implementation of "functional value over vanity metrics" — it's actually consistent with what your own `DESIGN_ROADMAP.md` asked for (completed-count-based recognition instead of streaks/badges), so no notes there.
- **Clean architecture is real, not aspirational** — domain/data/application/presentation boundaries are consistently followed across 180 files.

---

## Method note — what I could and couldn't check

I audited this by reading source directly on your machine and running targeted searches (grep-based static analysis), because the shell available to me on your computer is sandboxed to the connected `YordamBor` folder and can't reach your Flutter SDK (installed at `/Users/Erkin/flutter`, outside that folder). That means everything above is confirmed by direct code inspection, but I could **not** run the Dart analyzer itself, which would additionally catch: type errors, unused imports/variables, unreachable code, and lint violations from your `flutter_lints` ruleset.

Please run these two commands yourself and skim the output — they take under a minute and will catch anything mechanical this audit couldn't:
```bash
cd yordambor_app
flutter analyze
flutter pub outdated
```

---

## Suggested fix order

1. `git init` + commit (5 min, protects everything else)
2. iOS Info.plist permission strings (10 min, unblocks iOS testing entirely)
3. Demo listing guard — at minimum, disable the offer button on `isDemo` items (~1 hr)
4. Run `flutter analyze` yourself and fix whatever it surfaces
5. Controller disposal fixes (batch, ~1 hr for all 9 files)
6. `.single()` → `.maybeSingle()` on the two read sites (~20 min)
7. Chinese translation gaps + freezed version pin (whenever convenient — neither blocks testing)
