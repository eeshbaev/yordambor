# YordamBor — Design Roadmap

**Elite product design applied to a Uzbekistan services marketplace**

Aligned with [YORDAMBOR_BUILD_PLAN.md](./YORDAMBOR_BUILD_PLAN.md) · [ONBOARDING_DESIGN.md](./ONBOARDING_DESIGN.md) · [IMPLEMENTATION_PLAN.md](./IMPLEMENTATION_PLAN.md)

---

## 0. The one sentence

> **YordamBor helps people find trusted help and close real deals — not scroll forever.**

Every design decision must pass:

**Does this help the user reach their goal faster, easier, or with greater satisfaction?**

If no → remove it.

---

## 1. YordamBor design north star

### Human behaviors we optimize for

| User | Behavior | Emotion | Outcome |
|------|----------|---------|---------|
| **Client** | “I need a plumber today” | Relief, confidence | Finds provider → Kelishuv → job done |
| **Provider** | “I want more clients” | Pride, recognition | Portfolio seen → Taklif → completed work |
| **Both** | “Is this person legit?” | Trust | Photos, reviews, clear deal status |

### What YordamBor is NOT

- Not a social feed (no infinite vanity engagement)
- Not a chat app (Kelishuv is deal-scoped, purposeful)
- Not a gamified streak machine (trust > dopamine tricks)
- Not a settings-heavy product (smart defaults)

### Core design metaphor

**Portfolio-first discovery · Deal-scoped negotiation · Trust through proof**

---

## 2. Principle audit for YordamBor

Legend: ✅ Done · 🟡 Partial · 🔴 Not started · ⛔ Do not apply (or v2+ only)

### Tier A — Must implement (v1 launch blockers)

These principles directly affect trust, conversion, and the core loop.

| # | Principle | YordamBor application | Status |
|---|-----------|----------------------|--------|
| **0** | Human behavior first | Every screen answers: client finding help or provider getting work | 🟡 |
| **1** | Eliminate choice | 3 tabs; one primary CTA per screen; mode picker not 7 post types | 🟡 |
| **2** | Reduce taps | Auth bottom sheet; Kelishuv inline; remember last filter | 🟡 |
| **3** | Thumb-first | Bottom nav, FAB, bottom sheets, 52px CTAs | 🟡 |
| **8/18/76** | Empty states | Feed, favorites, kelishuvlar, inbox — illustration + CTA | 🔴 |
| **9/24/64** | Onboarding = promise | Guest-first; value in 30s via portfolio cards | ✅ |
| **11/29** | Trust | Predictable layouts; undo where safe; no fake urgency | 🟡 |
| **13–15** | Hierarchy + whitespace + scan | One hero per card; portfolio image dominates | 🔴 |
| **16** | Consistency | Design system tokens before Sprint 2 screens | 🔴 |
| **19/41/70** | Loading = skeleton | Feed cards, profile, kelishuv list | 🔴 |
| **20/74/75** | Errors explained | Auth errors ✅; form validation; blocked Kelishuv reasons | 🟡 |
| **22** | Forms minimal | Register ✅; Taklif ≥1 field; slot picker not 12 fields | 🟡 |
| **32** | Bottom nav 3–5 | Asosiy · Saqlangan · Profil | ✅ |
| **35/84** | Content is hero | Full-bleed portfolio cards; minimal chrome on scroll | 🔴 |
| **38** | One card = one story | Xizmat card: photo · name · soha · ♥ · one action | 🔴 |
| **40** | One FAB | E’lon qoldirish (Yordam Kerak only) | ✅ |
| **55** | Functional value | Completed deals, reviews, saved providers — not vanity metrics | 🔴 |
| **57** | Platform native | iOS spring + haptics; Android Material motion + predictive back | 🔴 |
| **67** | Design for failure | Offline, slow network, empty Supabase, session expired | 🔴 |
| **68/69** | Returning users | Continue Kelishuv; draft Taklif; recent soha filter | 🔴 |
| **72–73** | No hidden/stuck UI | Safe areas; always back/close; no trap modals | 🟡 |
| **77** | Every tap responds | Loading on all async actions | 🟡 |
| **79/80** | Clarity over minimalism | Labels on Kelishuv states; explain disabled CTAs | 🔴 |
| **81** | Button economy | Taklif screen: one primary (Yuborish) | 🔴 |
| **82** | Touch targets ≥48dp | Audit all tappable areas | 🟡 |
| **101** | Typography system | 5-level scale; Dynamic Type ready | 🔴 |
| **102** | Information architecture | Where Kelishuv lives; inbox per xizmat | 🟡 |
| **106** | All states designed | Empty/loading/error/success/offline per screen | 🔴 |
| **107** | Time to value | Guest sees portfolio ≤30s after install | 🔴 |
| **Ethics** | No manipulation | No guilt streaks; no “we miss you”; no fake countdown | ✅ policy |

### Tier B — Implement in polish phase (v1.1 – v1.2)

| # | Principle | YordamBor application |
|---|-----------|----------------------|
| **4/17** | Feel alive | Card press 98%; ♥ pop; state transition 200ms |
| **5** | Physics | Pull-to-refresh elastic; sheet spring |
| **6** | Haptics | ♥, Qabul qilaman, Bajarildi, payment-less success |
| **7/33** | Swipe gestures | Swipe kelishuv archive; swipe notification dismiss |
| **12/30/49** | Delight (rare) | Confetti on first Bajarildi only — not every tap |
| **23/53** | Notifications | Human-only: new Taklif, accept, message, Bajarildi reminder |
| **25** | Permissions when needed | Photos on portfolio upload; push after first Kelishuv |
| **36** | Smart defaults | Last currency, last soha, last slot duration |
| **37/85** | Progressive disclosure | Taklif: simple first → optional narx/muddat expand |
| **42** | Pull to refresh | Home feed, Menga kelgan inbox |
| **43/44** | Depth + glass | Nav bar blur on scroll; modal elevation |
| **48** | Recognition | Review count, completed jobs on profile |
| **58/59** | Icons + illustrations | Empty states; error states; celebration |
| **61** | Predictability | ♥ always saves; Yordam Bor always = Taklif |
| **62** | Infinite journey | After Taklif sent → “Kelishuvingiz kuzatilmoqda” + next step |
| **66** | Respect attention | Batch low-priority notifications |
| **87/88** | Theme + language resilience | Dark mode; UZ/RU/EN/ZH layout stress test |
| **90** | Privacy clarity | Client Book local-only explained in UI |
| **96/97** | Brand + motion language | Teal trust color; 200ms standard easing |
| **103** | Discoverability | One-time coach mark for filters (Sprint 2a) |
| **104** | Reversibility | Undo favorite; cancel Muzokarada with confirm |
| **109** | Adaptive design | Edge-to-edge; tablet/large phone layouts |

### Tier C — v2+ or selective only

| # | Principle | Why later / conditional |
|---|-----------|---------------------------|
| **10/26/27** | Streaks, badges, levels | Marketplace trust ≠ game; use **completed count** instead |
| **21/46** | Search-first | Filters (Soha/Subsoha) first; universal search v2 |
| **28** | Community | Reviews + replies only — not open social graph |
| **52** | Widgets | “Active Kelishuv” widget after core loop proven |
| **54/63** | Emotional retention architecture | Built through reviews + repeat providers, not streaks |
| **AI-native UX** | Smart soha suggestion, draft Taklif — v2 |
| **105** | Defaults as design | Expand after usage data |

### Tier D — Explicitly rejected for YordamBor

| Pattern | Reason |
|---------|--------|
| Daily “open app” streaks | Manipulative for a utility marketplace |
| Leaderboards of providers | Race to bottom; wrong incentive |
| “We miss you” push | Violates P53 + ethics |
| 5+ bottom tabs | P1: Kelishuv lives in Profil/notifications, not 4th tab |
| Chat with photos in deals | Product rule: no photos in Kelishuv |
| Onboarding carousel | Already removed ✅ |
| Barchasi / dead filters | Already removed ✅ |

---

## 3. YordamBor design system (build before Sprint 2 UI)

Create `lib/core/design_system/` — this enforces P16, P101, P105.

### 3.1 Tokens

```
Spacing:  4 · 8 · 12 · 16 · 24 · 32 · 48 (8pt grid)
Radius:   8 (chip) · 12 (card) · 16 (sheet) · full (FAB)
Touch:    min 48×48 logical px

Typography (Inter or SF/system):
  display   28/w700  — Welcome title
  title     20/w700  — Screen title, card name
  headline  17/w600  — Section headers
  body      15/w400  — Descriptions
  caption   13/w400  — Meta, timestamps
  label     12/w600  — Chips, tabs

Colors (semantic, not raw):
  primary       #0D9488  — CTAs, active tab
  primaryMuted  primary @ 12%
  surface       #F8FAFC
  card          #FFFFFF
  textPrimary   #0F172A
  textSecondary #64748B
  success       #059669  — Jarayonda, Bajarildi
  warning       #D97706  — Muzokarada
  error         #DC2626
  border        #E2E8F0

Motion:
  fast    150ms — button press, toggle
  normal  250ms — sheet, card state
  slow    350ms — page transition
  spring  Curves.easeOutCubic / iOS spring on platform
```

### 3.2 Components (reusable widgets)

| Component | Used on |
|-----------|---------|
| `YbPrimaryButton` | All primary CTAs — 52px height |
| `YbSecondaryButton` | Outlined actions |
| `YbFilterChip` | Home filter bar |
| `YbXizmatCard` | Home feed, favorites |
| `YbEmptyState` | All empty screens |
| `YbSkeletonCard` | Feed loading |
| `YbStatusBadge` | Kelishuv: Muzokarada / Jarayonda / Bajarildi |
| `YbBottomSheet` | Auth, Taklif, filters, confirmations |
| `YbConfirmDialog` | Qabul qilaman, Bekor, Bajarildi |
| `YbSnackbar` | Success/error with action |
| `YbPortfolioGallery` | Xizmat profile hero |

### 3.3 Iconography rules (P58)

| Action | Icon | Never use |
|--------|------|-----------|
| Save | `favorite` / ♥ | bookmark, star |
| Offer help | `handshake` or brand | “Connect” |
| Post need | `add` + E’lon | megaphone only in empty state |
| Deal | `description` or custom Kelishuv | chat bubble as primary |
| Notify | `notifications` | bell variants per screen |

---

## 4. Screen design specs

### 4.1 Home — Yordam Bor (default)

**Primary action:** Tap portfolio card → Xizmat profile  
**Secondary:** ♥ save (guest → auth sheet)

```
┌─────────────────────────────────────┐
│ YordamBor                      🔔   │  ← collapses on scroll (P35)
├─────────────────────────────────────┤
│ [Yordam Bor ▾] [Soha ▾] [Subsoha ▾] │  ← horizontal scroll, 3 chips only
├─────────────────────────────────────┤
│ ┌─────────────────────────────────┐ │
│ │  [PORTFOLIO HERO IMAGE 16:9]    │ │  ← edge-to-edge card
│ │  Sanjar — Santexnika            │ │
│ │  ★ 4.8 · 23 bajarilgan          │ │
│ │                          ♥      │ │
│ └─────────────────────────────────┘ │
│ ┌─────────────────────────────────┐ │
│ │  next card…                     │ │
│ └─────────────────────────────────┘ │
└─────────────────────────────────────┘
│ Asosiy    Saqlangan    Profil       │
```

**Empty state (P76):**  
“Ishingizni ko‘rsating” for providers / “Tez orada ustalar” for clients — with **seed demo cards** at launch so first install is never blank.

**Loading:** 3× skeleton cards (P41).

---

### 4.2 Home — Yordam Kerak

**Primary action:** FAB **E’lon qoldirish** (bottom-right, thumb zone)  
**Card action:** **Yordam Bor** → auth → Taklif sheet

FAB hidden when filter = Yordam Bor (P40: one FAB, one context).

---

### 4.3 Xizmat profile

**Hero:** Portfolio carousel (swipe, P33) — this IS the trust builder  
**One primary CTA:** **Yordam Bor** (Taklif yuborish)  
**Secondary:** ♥ · Share (App Store link only)

No wall of buttons. Description collapsed with “Ko‘proq”.

---

### 4.4 Kelishuv (deal) screen

**State-driven UI (P80)** — user always knows where they are:

| Status | Primary CTA | Color badge |
|--------|-------------|-------------|
| Muzokarada | Qabul qilaman / counter-offer | warning |
| Jarayonda (0–3d) | Tahrirlash / Bekor | success |
| Jarayonda (3d+) | Locked — info only | success muted |
| Bajarildi pending | Bajarildi (receiver only) | primary |
| Bajarildi | Sharh qoldirish | neutral |

**Confirm pattern:** Every Qabul → “Ishonchingiz komilmi?” (P11 trust)  
**No photos** in timeline — text + price + slot only.

---

### 4.5 Profil

| State | Content |
|-------|---------|
| Guest | Welcome card + Kirish / Ro‘yxat |
| Auth unverified | Verify email banner |
| Auth verified | Avatar · name · Mening xizmatlarim · Kelishuvlar · Sozlamalar |
| Provider prompt | One-time “Xizmat ko‘rsatasizmi?” card ✅ |

**Kelishuvlar entry:** List with status badges — not a 4th tab (P32).

---

## 5. Edge-to-edge & adaptive (P109, your global rule)

### v1 requirements

- [ ] `SafeArea` only where system UI overlaps — content goes edge-to-edge
- [ ] Android: `enableEdgeToEdge()` + transparent status/nav bar
- [ ] iOS: respect home indicator; FAB above safe inset
- [ ] Remove orientation locks — support portrait primary, graceful landscape on tablets
- [ ] Test: iPhone SE · iPhone 15 Pro Max · small Android · tablet
- [ ] No button under system gesture bar (P72)

---

## 6. Notification design (P53 — human only)

### Send

| Event | Copy (UZ) | Priority |
|-------|-----------|----------|
| New Taklif | “Sanjar sizga taklif yubordi” | Immediate |
| Qabul qilaman (both) | “Kelishuv tasdiqlandi — Jarayonda” | Immediate |
| New message in Kelishuv | “Kelishuvda yangi xabar” | Immediate |
| Day 3 reminder | “Bajarildi ni tasdiqlash mumkin” | Scheduled |
| Eslatma (local) | User-created reminder | User-defined |

### Never send

- “We miss you”
- “Open the app”
- Daily digest of likes/views
- Marketing without value

### Permission ask (P25)

After **first Kelishuv accepted**:  
“Kelishuvlar haqida xabar olish uchun bildirishnomalarni yoqing.”

---

## 7. Motion & haptics map

| Moment | Visual | Haptic | Sound |
|--------|--------|--------|-------|
| Button press | scale 0.98, 150ms | none | none |
| ♥ save | scale 1.2→1.0, fill | light | none |
| Taklif sent | checkmark slide | medium | optional v1.1 |
| Qabul qilaman | badge flip | medium | none |
| Jarayonda | status color transition | success | none |
| Bajarildi | subtle confetti once | heavy | optional v1.1 |
| Pull refresh | elastic | light at trigger | none |

**Rule:** No sound by default (P60 — opt-in in Sozlamalar).

---

## 8. Implementation roadmap

Aligned with engineering sprints. **Design tasks run parallel — design system before each sprint’s UI.**

### Phase D0 — Design foundation (Week 1, parallel to Sprint 2 start)

| Task | Principles | Deliverable |
|------|------------|-------------|
| D0.1 Design tokens in Flutter | P16, P101, P105 | `app_tokens.dart`, update `app_theme.dart` |
| D0.2 Component library v1 | P16, P38, P82 | 10 core widgets listed in §3.2 |
| D0.3 Motion constants | P97 | `app_motion.dart` |
| D0.4 Empty + skeleton templates | P8, P19, P41, P76 | `YbEmptyState`, `YbSkeletonCard` |
| D0.5 Edge-to-edge setup | P109, P72 | Android/iOS config |

### Phase D1 — Discovery UX (Sprint 2)

| Task | Principles | Deliverable |
|------|------------|-------------|
| D1.1 Xizmat card design | P13, P35, P38, P84 | Portfolio hero feed |
| D1.2 Xizmat profile | P35, P62, P103 | Gallery + one CTA |
| D1.3 Soha/Subsoha picker | P1, P2, P37 | Bottom sheet taxonomy |
| D1.4 Favorites UX | P4, P6, P104 | ♥ animation + undo snackbar |
| D1.5 Feed empty + seed | P76, P107 | Demo cards + provider CTA |
| D1.6 Coach marks (3 max) | P103, P9 | Filters, ♥, Profil — once |

### Phase D2 — Kelishuv UX (Sprint 3)

| Task | Principles | Deliverable |
|------|------------|-------------|
| D2.1 Taklif bottom sheet | P1, P2, P22, P37 | ≥1 field, expandable narx/muddat |
| D2.2 Kelishuv timeline | P15, P80, P102 | Status badges, clear CTAs |
| D2.3 Confirm dialogs | P11, P29 | Ishonchingiz komilmi? |
| D2.4 Menga kelgan inbox | P38, P40 | Per-xizmat inbox list |
| D2.5 Blocked state copy | P74, P75 | Why Qabul disabled |
| D2.6 First-deal notification pre-prompt | P25, P53 | Permission sheet |

### Phase D3 — Provider tools (Sprint 4)

| Task | Principles | Deliverable |
|------|------------|-------------|
| D3.1 Create Xizmat 3-step | P9, P22, P107 | Photo required gate |
| D3.2 Client Book UI | P90, P69 | Local-only explanation |
| D3.3 Eslatmalar | P53, P25 | Contextual reminder setup |
| D3.4 Daromad summary | P55, P10 | Functional progress, not gamification |
| D3.5 Review + reply | P48, P28 | Recognition through quality |

### Phase D4 — Polish & launch (Sprint 5)

| Task | Principles | Deliverable |
|------|------------|-------------|
| D4.1 Dark mode | P87 | Full token review |
| D4.2 i18n layout stress | P88 | UZ/RU/EN/ZH overflow audit |
| D4.3 Offline/error states | P67, P106 | Every screen |
| D4.4 Haptics pass | P6 | Core loop moments |
| D4.5 Elite audit (P56) | All | Squint test every screen |
| D4.6 Accessibility baseline | WCAG | Dynamic Type, contrast 4.5:1, screen reader labels on CTAs |
| D4.7 App Store screenshots | P99 | Portfolio-first story |

### Phase D5 — Post-launch (v1.1+)

| Task | Principles |
|------|------------|
| Home screen widget (active Kelishuv) | P52 |
| Universal search | P21, P46 |
| Smart defaults from behavior | P36, P105 |
| AI: suggest soha from photo/title | AI-native UX |
| Tablet-optimized two-pane | P109 |

---

## 9. Master design TODO checklist

Copy into project tracker. Order = priority.

### 🔴 Critical (before Sprint 2 ships)

- [ ] **DS-01** Create design tokens file (spacing, type, color, radius, motion)
- [ ] **DS-02** Build `YbPrimaryButton` + `YbSecondaryButton` (52px, full-width)
- [ ] **DS-03** Build `YbEmptyState` (illustration + title + body + CTA)
- [ ] **DS-04** Build `YbSkeletonCard` for feed
- [ ] **DS-05** Build `YbXizmatCard` — one story: photo · name · rating · ♥
- [ ] **DS-06** Edge-to-edge on Android + iOS safe area audit
- [ ] **UX-01** Home feed: portfolio-first vertical scroll (not grid — easier thumb scan)
- [ ] **UX-02** Soha/Subsoha bottom sheet picker (replace snackbar placeholders)
- [ ] **UX-03** Seed 3 demo xizmatlar so first open has value (P107)
- [ ] **UX-04** ♥ with auth gate + light haptic + optimistic UI
- [ ] **UX-05** Collapsing app bar on scroll (P35)

### 🟡 High (Sprint 3)

- [ ] **UX-06** Xizmat profile with portfolio carousel
- [ ] **UX-07** Taklif bottom sheet — progressive fields
- [ ] **UX-08** Kelishuv status badges + color system
- [ ] **UX-09** “Ishonchingiz komilmi?” confirm pattern
- [ ] **UX-10** Explain disabled CTAs inline (P74)
- [ ] **UX-11** Pull-to-refresh on feed
- [ ] **UX-12** Notification permission pre-prompt (after first deal)
- [ ] **UX-13** Menga kelgan inbox per xizmat

### 🟢 Polish (Sprint 4–5)

- [ ] **UX-14** 3 coach marks (filters, ♥, profil) — once ever
- [ ] **UX-15** Bajarildi celebration (subtle, once per deal)
- [ ] **UX-16** Review screen with provider reply
- [ ] **UX-17** Dark mode
- [ ] **UX-18** Dynamic Type / accessibility labels
- [ ] **UX-19** Offline banner + retry
- [ ] **UX-20** Draft Taklif persistence (P69)
- [ ] **UX-21** Continue Kelishuv on app open (P68)
- [ ] **UX-22** Monthly friction audit (P50) — remove unused UI

### ⛔ Never build

- [ ] ~~Streak counter for app opens~~
- [ ] ~~“We miss you” notifications~~
- [ ] ~~Provider leaderboard by volume~~
- [ ] ~~4th bottom tab for Kelishuv~~
- [ ] ~~Photo sharing inside Kelishuv chat~~
- [ ] ~~Multi-slide onboarding carousel~~

---

## 10. Screen scorecard (use before shipping each screen)

For every screen, answer **Yes/No**:

| Test | Question |
|------|----------|
| Squint (P13) | Is the primary action obvious in 1 second? |
| Tap count (P2) | Can the main outcome happen in ≤3 taps? |
| Thumb (P3) | Is primary action in bottom 40% of screen? |
| Empty (P76) | Does empty state guide next action? |
| Loading (P19) | Skeleton shown within 100ms? |
| Error (P20) | Errors human-readable in Uzbek? |
| Trust (P11) | No dark patterns or fake urgency? |
| Remove (P50) | Can anything on this screen be deleted? |
| Alive (P77) | Does every tap get instant feedback? |
| Exit (P73) | Can user always go back? |

**Ship only when ≥9/10 are Yes.**

---

## 11. What “world class” looks like for YordamBor

Not Duolingo streaks. Not Instagram reels. **Airbnb trust × Linear polish × local Uzbek clarity.**

Users should feel:

- *“I can see their real work”* → portfolio hero
- *“I know where this deal stands”* → Kelishuv status system
- *“This app respects my time”* → guest browse, minimal taps, no spam
- *“I trust this”* → reviews, clear rules, no tricks

---

## 12. Relationship to engineering sprints

| Engineering | Design phase | Exit visual criteria |
|-------------|--------------|----------------------|
| Sprint 1a ✅ | Onboarding spec ✅ | Welcome + auth sheet polished |
| Sprint 2 | **D0 + D1** | Feed looks alive with real cards |
| Sprint 3 | **D2** | Kelishuv understandable without tutorial |
| Sprint 4 | **D3** | Provider tools feel professional |
| Sprint 5 | **D4** | Passes P56 elite audit |

---

*Design roadmap v1 · August 2026 · YordamBor*
