#!/bin/sh
set -e

echo "==> Running database migrations..."
python manage.py migrate --noinput || echo "Migration warning: proceeding..."

echo "==> Starting Gunicorn on port ${PORT:-8000}..."
exec "$@"
