#!/usr/bin/env bash
# Exit on error
set -o errexit

echo "==> Upgrading pip and installing requirements..."
pip install --upgrade pip
pip install -r requirements.txt

echo "==> Collecting static assets via WhiteNoise..."
python manage.py collectstatic --no-input

echo "==> Running database migrations..."
python manage.py migrate
