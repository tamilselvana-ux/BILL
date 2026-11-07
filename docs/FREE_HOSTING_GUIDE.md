# 🌐 Free Hosting Guide for AVT Flower Terminal

This guide explains the best options to host your Django application with PostgreSQL, Google Sheets OAuth, ReportLab PDF generation, and WhiteNoise static files **100% free of charge**.

---

## 🏆 Top 3 Free Hosting Strategies Compared

| Platform Setup | Cost | Database | Always-On / Sleep? | Custom Domain & SSL | Best For |
|---|---|---|---|---|---|
| **Option 1: Render + Neon PostgreSQL** *(Recommended)* | **$0/mo** | Neon Free Postgres (0.5 GB, always free) | Sleeps after 15 min inactivity (~30s wake-up) | ✅ Free SSL + Custom Domain | **Best overall production setup, automated git deploys** |
| **Option 2: PythonAnywhere** | **$0/mo** | SQLite (Persists on disk) or MySQL | ⚡ **Always-on** (No sleep!), renew button every 3 months | ❌ Needs paid plan for custom domain (`.pythonanywhere.com` is free) | **Easiest setup, zero database config needed** |
| **Option 3: Koyeb + Neon PostgreSQL** | **$0/mo** | Neon Free Postgres | 1 Free Nano instance (512MB RAM) | ✅ Free SSL + Custom Domain | **Modern container/git alternative to Render** |

---

## 🥇 Option 1 (Recommended): Render + Neon PostgreSQL

This is the standard professional architecture:
- **Web App**: Hosted on [Render.com](https://render.com) (Free Web Service)
- **Database**: Hosted on [Neon.tech](https://neon.tech) (Free Serverless PostgreSQL, 0.5 GB storage, never expires)
- **Static Assets**: Handled automatically by WhiteNoise
- **Media & Sheet DB**: Saved directly to Google Drive / Google Sheets (15 GB free per Google account)

### Step 1: Create a Free PostgreSQL Database on Neon
1. Go to [https://neon.tech](https://neon.tech) and sign up with GitHub or Google.
2. Click **Create Project** (e.g. `avt-flower-db`).
3. Neon will immediately display your connection details. Copy the **Connection String** ending with `?sslmode=require`.
   - Format: `postgres://<user>:<password>@<endpoint>.neon.tech/neondb?sslmode=require`
   - This string will be your `DATABASE_URL`.

---

### Step 2: Push Your Code to GitHub
1. Initialize git (if not already done) and commit your codebase:
   ```bash
   git init
   git add .
   git commit -m "Production-ready AVT Flower Terminal with Google Sheets OAuth"
   ```
2. Create a new repository on [GitHub](https://github.com/new) (Private or Public).
3. Push your repository:
   ```bash
   git remote add origin https://github.com/<your-username>/<repo-name>.git
   git branch -M main
   git push -u origin main
   ```

---

### Step 3: Deploy on Render
1. Go to [https://render.com](https://render.com) and sign in with GitHub.
2. Click **New +** → **Web Service**.
3. Select your GitHub repository (`<repo-name>`).
4. Configure the settings:
   - **Name:** `avt-flower-terminal` (or your choice)
   - **Region:** Singapore or Frankfurt (choose nearest to India)
   - **Branch:** `main`
   - **Runtime:** `Python 3`
   - **Build Command:** `./build.sh` (or `pip install -r requirements.txt && python manage.py collectstatic --no-input && python manage.py migrate`)
   - **Start Command:** `gunicorn config.wsgi:application`
   - **Instance Type:** Select **Free**
5. Under **Environment Variables**, click **Add Environment Variable** and enter:

| Key | Example Value | Description |
|---|---|---|
| `DJANGO_DEBUG` | `False` | Disables debug mode for production security |
| `DJANGO_SECRET_KEY` | *(Generate a 50-char random key)* | Django security key |
| `DATABASE_URL` | `postgres://user:pass@ep.neon.tech/neondb?sslmode=require` | Copied from Neon |
| `DJANGO_ALLOWED_HOSTS` | `.onrender.com,localhost` | Allows Render subdomains |
| `CSRF_TRUSTED_ORIGINS` | `https://*.onrender.com` | Prevents 403 CSRF verification errors |
| `ADMIN_CONTACT_NUMBER` | `+91 98410 00000` | Support contact for pending shops |
| `GOOGLE_CLIENT_ID` | `xxx.apps.googleusercontent.com` | Google Cloud OAuth Client ID |
| `GOOGLE_CLIENT_SECRET` | `GOCSPX-xxx` | Google Cloud OAuth Client Secret |
| `GOOGLE_OAUTH_REDIRECT_URI` | `https://<your-render-name>.onrender.com/super-admin/google/callback/` | Authorized OAuth redirect URL |
| `GOOGLE_DRIVE_FOLDER_NAME` | `AVT Flower Market - Merchant Sheets` | Admin Drive parent folder |
| `FIELD_ENCRYPTION_KEY` | *(32-byte Fernet base64 key)* | Key to encrypt OAuth tokens at rest |

6. Click **Deploy Web Service**.
7. Render will automatically build the app, run migrations, collect static files, and launch Gunicorn.
8. Once deployed, open the Render **Shell** tab and run:
   ```bash
   python manage.py seed_demo
   # or create your own custom superadmin:
   python manage.py createsuperuser
   ```

---

## 🥈 Option 2: PythonAnywhere (All-in-One, No Database Setup)

If you want a 100% free solution where SQLite runs directly on disk with **zero spin-down / no sleep time**:

1. Sign up for a free "Beginner" account at [https://www.pythonanywhere.com](https://www.pythonanywhere.com).
2. Open a **Bash Console** and clone your repo:
   ```bash
   git clone https://github.com/<your-username>/<repo-name>.git
   cd <repo-name>
   mkvirtualenv --python=/usr/bin/python3.10 avt-venv
   pip install -r requirements.txt
   python manage.py migrate
   python manage.py collectstatic
   python manage.py seed_demo
   ```
3. Go to the **Web** tab in PythonAnywhere:
   - Click **Add a new web app** (choose Manual configuration → Python 3.10).
   - Set **Virtualenv** to: `/home/<username>/.virtualenvs/avt-venv`.
   - Set **Source code** to: `/home/<username>/<repo-name>`.
   - Edit the **WSGI configuration file** to point to your Django `config.wsgi`:
     ```python
     import os
     import sys
     path = '/home/<username>/<repo-name>'
     if path not in sys.path:
         sys.path.append(path)
     os.environ['DJANGO_SETTINGS_MODULE'] = 'config.settings'
     from django.core.wsgi import get_wsgi_application
     application = get_wsgi_application()
     ```
   - In **Static files**, map:
     - URL: `/static/` → Directory: `/home/<username>/<repo-name>/staticfiles`
4. Click **Reload <username>.pythonanywhere.com** and your app is live!
   - *Note:* PythonAnywhere free accounts require you to click a button once every 3 months to extend your free web app.

---

## 🥉 Option 3: Koyeb (Modern Container & Micro Engine)

1. Sign up at [https://www.koyeb.com](https://www.koyeb.com).
2. Connect your GitHub repository.
3. Koyeb will automatically detect your `Dockerfile` (already included in this repo) or buildpack.
4. Set the **Port** to `8000`.
5. Add the same environment variables as Render (`DATABASE_URL` pointing to Neon, `DJANGO_SECRET_KEY`, etc.).
6. Click **Deploy**. Koyeb provisions free SSL and high-speed edge routing.

---

## 💡 Pro Tips for Free Hosting

### 1. How to Prevent Free Render App from Sleeping
Render free web services spin down after 15 minutes of no web traffic. When a new visitor opens the site, it takes ~30 seconds for the container to start up.
To prevent this:
- Sign up for a free uptime monitor like [UptimeRobot](https://uptimerobot.com) or [Cron-Job.org](https://cron-job.org).
- Add an HTTP monitor pointing to your health check URL: `https://<your-app>.onrender.com/health/` every 10 minutes.
- This keeps the free server warm so it never sleeps!

### 2. Updating Google Cloud Console Redirect URI
After deploying to Render or PythonAnywhere, remember to add your new production URL to your **Google Cloud Console**:
1. Go to **Google Cloud Console** → **APIs & Services** → **Credentials**.
2. Click your OAuth 2.0 Client ID.
3. Under **Authorized redirect URIs**, add:
   `https://<your-render-name>.onrender.com/super-admin/google/callback/`
4. Save changes.
