# YordamBor v1 — Build Plan

Mobile app only · Flutter + Supabase + Riverpod · Clean architecture

---

## 1. What remains in this repo

```
YordamBor/
├── data/
│   ├── categories.json      # Seed data (21 soha, 363 subsoha, UZ/RU/EN)
│   └── categories.ts        # Reference copy of taxonomy helpers
├── docs/
│   ├── categories-taxonomy.md
│   └── YORDAMBOR_BUILD_PLAN.md   ← this file
└── yordambor-logo.svg
```

The old Next.js prototype has been removed. Taxonomy is the only ported asset.

---

## 2. Product summary (locked)

### Core loop

```
Discover (Yordam Bor / Yordam Kerak feed)
  → Xizmat profile or job post
  → Kelishuv (deal-scoped negotiation)
  → Dual accept → Jarayonda
  → Bajarildi (receiver, after 3 days)
  → Review → Archive
```

### Navigation

| Layer | Content |
|-------|---------|
| Top | YordamBor title · 🔔 notifications |
| Home filters | Yordam Bor ▾ (default) · Barchasi · Soha · Subsoha · Mutaxassis \| Tashkilot |
| Bottom tabs | Asosiy · Saqlangan · Profil |
| FAB | E'lon qoldirish (when filter = Yordam Kerak) |

### Key rules

- **Taklif:** both sides; first sender ≥1 field (Xizmat often auto-filled)
- **Muddat:** slot model — boshlanish sana · vaqt · davomiylik
- **Accept:** both press Qabul qilaman + *Ishonchingiz komilmi?* each time
- **Muzokarada:** edit/message resets accepts; stale → archive 10d / delete 15d
- **Jarayonda:** days 0–3 edit (re-accept) or cancel; after day 3 locked; Bajarildi day 3+ (receiver)
- **Cancel in Jarayonda:** archive 5d / delete 10d
- **Completed:** archive 10d / delete 30d
- **One active Kelishuv per xizmat** per user pair; resend after archive
- **Narx:** optional; UZS or USD; platform is intermediary only
- **No photos** in deal timeline; phone optional in message / profile setting
- **Client Book (Mijoz kitobi):** local only on device; conflict warnings for provider
- **Eslatmalar:** in Profil; auto from Client Book + manual
- **Auth:** name, email, phone, password; verify email before first Kelishuv
- **Languages:** UZ · RU · EN · Chinese (full platform)
- **Max 5 xizmat** per user; separate Menga kelgan inbox per xizmat

---

## 3. Tech stack

| Layer | Choice |
|-------|--------|
| App | Flutter 3.x (iOS + Android) |
| State | Riverpod 2.x |
| Navigation | go_router |
| Backend | Supabase (Auth, Postgres, Realtime, Storage) |
| Models | freezed + json_serializable |
| Local | hive or sqflite — Client Book, Eslatmalar, offline cache |
| Push | firebase_messaging or flutter_local_notifications |
| Images | cached_network_image; Supabase Storage for portfolio |

### Project structure

```
yordambor_app/
├── lib/
│   ├── main.dart
│   ├── app.dart
│   ├── core/           # theme, constants, l10n, utils
│   ├── domain/         # entities, repository interfaces
│   ├── data/           # supabase repos, DTOs, local DB
│   ├── application/    # riverpod providers, notifiers
│   └── presentation/   # screens, widgets
├── assets/
│   └── i18n/
├── supabase/
│   ├── migrations/
│   └── seed/categories.sql
└── test/
```

---

## 4. Supabase schema (v1)

### Core tables

**profiles** — app user (not xizmat)
- id, full_name, email, phone, avatar_url, show_phone, language, created_at

**xizmatlar** — service profile (max 5 per user)
- id, owner_id, name, provider_type (individual|institution), category_id, subcategory_id
- description, avatar_url, status (available|busy), currency_default (UZS|USD)
- rating_avg, review_count, completed_count, created_at

**portfolio_items**
- id, xizmat_id, image_url, caption, is_hero, sort_order, created_at

**yordam_kerak_posts** — job board cards
- id, author_id, title, message, price, currency, slot fields, category_id, subcategory_id
- status (open|closed|deleted), created_at

**kelishuvlar** — deals
- id, xizmat_id, yordam_kerak_post_id (nullable), yordam_bor_user_id, yordam_kerak_user_id
- role_initiator, status (muzokarada|jarayonda|bajarildi|bekor|rad)
- message, price, currency, start_date, start_time, duration_minutes, end_date
- accept_a, accept_b, accept_a_at, accept_b_at, jarayonda_at, bajarildi_at
- created_at, updated_at, archive_at, delete_at

**kelishuv_messages** — deal timeline (text only)
- id, kelishuv_id, sender_id, content, created_at

**reviews**
- id, kelishuv_id, xizmat_id, reviewer_id, rating, comment, provider_reply, created_at

**favorites**
- user_id, xizmat_id, created_at

**reports**
- id, reporter_id, target_type, target_id, reason, created_at

**blocks**
- blocker_id, blocked_id, created_at

**notifications** (cloud history; push separate)
- id, user_id, type, payload, read, created_at

**analytics_events** (or aggregate table per xizmat)
- xizmat_id, event_type, created_at

### RLS

- Public read: xizmatlar, portfolio, reviews, open yordam_kerak_posts, categories
- Auth write: own xizmat, own kelishuv participation, own favorites
- Kelishuv messages: participants only

### Seed

- Import `data/categories.json` → `categories` + `subcategories` tables (or JSONB config table)
- Add `zh` column when Chinese translations are ready

---

## 5. Build phases

### Phase 0 — Setup (week 1)

- [ ] Create Flutter project `yordambor_app` in repo or subfolder
- [ ] Supabase project: auth (email + phone metadata), storage bucket `portfolio`
- [ ] Run migrations + seed categories from `data/categories.json`
- [ ] App theme: mobile-first, bottom nav, brand colors from logo
- [ ] l10n scaffold: UZ, RU, EN, ZH (ARB or JSON)

### Phase 1 — Auth & shell (week 1–2)

- [ ] Guest browse shell (Asosiy empty state)
- [ ] Register: name, email, phone, password
- [ ] Login: email or phone + password; forgot password via email
- [ ] Email verification gate before first Kelishuv
- [ ] Bottom nav: Asosiy · Saqlangan · Profil
- [ ] Top bar: title + notification icon
- [ ] Profil: Sozlamalar, language, privacy, delete account

### Phase 2 — Xizmat & discovery (week 2–4)

- [ ] Create/edit xizmat (Xizmatlarim, max 5)
- [ ] Portfolio upload (Supabase Storage), hero image, captions
- [ ] Home filter bar: Yordam Bor / Yordam Kerak + soha + subsoha + type
- [ ] Yordam Bor feed: full-screen service cards (photo, name, rating, ♥)
- [ ] Yordam Kerak feed: job post cards + FAB E'lon qoldirish
- [ ] Public xizmat profile screen
- [ ] Favorites (♥ toggle, Saqlangan tab)
- [ ] Feed sort: filter match → rating → newest portfolio
- [ ] Gate: appear in feed only with ≥1 portfolio photo

### Phase 3 — Kelishuv engine (week 4–6)

- [ ] Open Kelishuv: from xizmat (Yordam Kerak) or job post (Yordam Bor)
- [ ] Deal header: role, topic, slot fields, narx, accept indicators
- [ ] Deal timeline: text messages, realtime via Supabase
- [ ] Edit fields → reset accepts; copy *Shartlar o'zgardi*
- [ ] Qabul qilaman + confirmation dialog
- [ ] Dual accept → Jarayonda; 3-day rules (edit/cancel/Bajarildi lock)
- [ ] Bajarildi + confirmation → review
- [ ] Menga kelgan: per-xizmat inbox
- [ ] Mening so'rovlarim / Kelishuvlar / Kelishuvlar arxivi
- [ ] One Kelishuv per xizmat per pair; 10-day stale archive
- [ ] Block user; report flag

### Phase 4 — Provider tools (week 6–7)

- [ ] Client Book (Mijoz kitobi) — local DB only
- [ ] Calendar: available / busy; manual entries
- [ ] Auto row on Jarayonda; conflict warning for provider
- [ ] Eslatmalar: list, edit, local push; auto from Client Book
- [ ] Mening daromadim: auto row on dual accept + manual table
- [ ] Analitika per xizmat: views, saves, in/out, conversion

### Phase 5 — Polish & ship (week 7–8)

- [ ] Full UZ/RU/EN/ZH strings
- [ ] Empty states all screens
- [ ] Share → App Store / Play Store links
- [ ] Retention jobs: archive/delete cron (Supabase Edge Function)
- [ ] Test on mid-range Android + iPhone
- [ ] Store listings, privacy policy, terms

---

## 6. Screen inventory

| Screen | Tab / entry |
|--------|-------------|
| Asosiy (Yordam Bor feed) | Tab 1 |
| Asosiy (Yordam Kerak feed) | Tab 1 + filter |
| Xizmat profile | Card tap |
| Yordam Kerak post detail | Card tap |
| Kelishuv room | CTA from card/post |
| Saqlangan | Tab 2 |
| Profil (guest) | Tab 3 |
| Profil (provider) | Tab 3 |
| Xizmatlarim list / edit | Profil |
| Menga kelgan (per xizmat) | Profil |
| Kelishuvlar / arxiv | Profil |
| Mijoz kitobi | Profil |
| Eslatmalar | Profil |
| Mening daromadim | Profil |
| Analitika | Profil → per xizmat |
| Auth register / login | Modal / Profil |
| Sozlamalar | Profil |
| Notifications list | 🔔 |

---

## 7. Local-only data (not Supabase)

| Data | Storage |
|------|---------|
| Client Book rows | hive/sqflite |
| Client Book calendar blocks | hive/sqflite |
| Eslatmalar (local triggers) | hive/sqflite |
| Scheduled local notifications | OS scheduler |

Settings copy: *Mijoz kitobi faqat shu qurilmada saqlanadi.*

---

## 8. What we deliberately dropped

- Website / Next.js
- In-app chat outside Kelishuv
- Ads, following, growth dashboard
- Location system (free text only)
- organizationSectors.ts (duplicate taxonomy)
- Old offers/messaging dual model
- Deep links to xizmat (v2)

---

## 9. Immediate next step

```bash
# From repo root, when ready to code:
flutter create yordambor_app
cd yordambor_app
flutter pub add flutter_riverpod go_router supabase_flutter freezed_annotation json_annotation hive_flutter flutter_local_notifications cached_network_image
```

Then: Supabase migrations from §4, seed from `data/categories.json`, implement Phase 0 → Phase 1.

---

## 10. Success criteria for v1 launch

- [ ] Guest can browse both feeds
- [ ] Provider can create xizmat + portfolio and appear in Yordam Bor feed
- [ ] Seeker can post Yordam Kerak and open Kelishuv from xizmat or post
- [ ] Full Kelishuv lifecycle through review
- [ ] Client Book + reminders work offline on device
- [ ] 4 languages selectable
- [ ] App builds for iOS and Android

---

*Last updated: August 2026 — aligned with product spec session.*
