#!/bin/sh
set -e

echo "==> Running database migrations..."
python manage.py migrate --noinput || echo "Migration warning: proceeding..."

# Auto-create or update Super Admin if environment variables are provided
if [ -n "$ADMIN_USERNAME" ] && [ -n "$ADMIN_PASSWORD" ]; then
    echo "==> Ensuring Super Admin ($ADMIN_USERNAME) exists..."
    python manage.py shell -c "
import os
from django.contrib.auth.models import User
username = os.environ.get('ADMIN_USERNAME')
password = os.environ.get('ADMIN_PASSWORD')
email = os.environ.get('ADMIN_EMAIL', 'admin@avtflowers.com')
u, created = User.objects.get_or_create(username=username, defaults={'email': email})
u.set_password(password)
u.is_superuser = True
u.is_staff = True
u.save()
print(f'==> Super Admin user {username} is ready.')
" || echo "Warning: Could not create admin user automatically."
fi

# Optional: Seed demo data if SEED_DEMO=True
if [ "$SEED_DEMO" = "True" ] || [ "$SEED_DEMO" = "true" ]; then
    echo "==> Seeding demo data..."
    python manage.py seed_demo || true
fi

echo "==> Starting Gunicorn on port ${PORT:-8000}..."
exec "$@"
