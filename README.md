# YordamBor

Mobile marketplace app for Uzbekistan — discover services, negotiate deals (**Kelishuv**), and connect via **Yordam Bor** (I can help) / **Yordam Kerak** (I need help).

## Status

The legacy Next.js prototype has been removed. This repo holds **taxonomy seed data** and the **v1 build plan** for the Flutter app.

## Contents

| Path | Description |
|------|-------------|
| [docs/DESIGN_ROADMAP.md](docs/DESIGN_ROADMAP.md) | **Design principles & UX roadmap** |
| [docs/ONBOARDING_DESIGN.md](docs/ONBOARDING_DESIGN.md) | **Onboarding UX system** |
| [docs/IMPLEMENTATION_PLAN.md](docs/IMPLEMENTATION_PLAN.md) | **Sprint-by-sprint implementation plan** |
| [docs/YORDAMBOR_BUILD_PLAN.md](docs/YORDAMBOR_BUILD_PLAN.md) | Product summary & architecture |
| [docs/categories-taxonomy.md](docs/categories-taxonomy.md) | 21 soha + subsoha (human-readable) |
| [data/categories.json](data/categories.json) | Taxonomy for Supabase / Flutter seed |
| [data/categories.ts](data/categories.ts) | Reference copy with helper types |
| [yordambor-logo.svg](yordambor-logo.svg) | Brand logo |

| [yordambor_app/](yordambor_app/) | **Flutter app** (Sprint 0 started) |

## Privacy policy (Google Play)

Static legal pages for the Play Store live in [`docs/`](docs/):

| Page | Path |
|------|------|
| Privacy (English) | `docs/privacy.html` |
| Privacy (RU / UZ) | `docs/privacy-ru.html`, `docs/privacy-uz.html` |
| Terms | `docs/terms.html` |

After pushing to GitHub and enabling **Pages → /docs**, use:

`https://YOUR_USERNAME.github.io/yordambor/privacy.html`

See [docs/GITHUB_PAGES_SETUP.md](docs/GITHUB_PAGES_SETUP.md) for step-by-step instructions.
