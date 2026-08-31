# Publish privacy policy on GitHub Pages

## 1. Create the GitHub repository

1. Go to [github.com/new](https://github.com/new)
2. Repository name: `yordambor` (or `YordamBor`)
3. **Public** (required for free GitHub Pages)
4. Do **not** add README if you already have local files
5. Create repository

## 2. Push this project

From the project root (`YordamBor/`):

```bash
git init -b main
git add .
git commit -m "Add YordamBor app and GitHub Pages legal site"
git remote add origin https://github.com/YOUR_USERNAME/yordambor.git
git push -u origin main
```

Replace `YOUR_USERNAME` with your GitHub username.

## 3. Enable GitHub Pages

1. GitHub repo → **Settings** → **Pages**
2. **Build and deployment** → Source: **Deploy from a branch**
3. Branch: **main** → Folder: **/docs**
4. Save

Wait 1–2 minutes. Your site will be live at:

```
https://YOUR_USERNAME.github.io/yordambor/
```

## 4. Google Play Console URLs

| Field | URL |
|-------|-----|
| **Privacy policy** | `https://YOUR_USERNAME.github.io/yordambor/privacy.html` |
| Terms (optional) | `https://YOUR_USERNAME.github.io/yordambor/terms.html` |

Paste the **privacy** URL in Play Console → App content → Privacy policy.

## 5. Update contact email (optional)

Edit `docs/privacy.html` and change `eeshbaev@outlook.com` if you prefer a dedicated support address.
