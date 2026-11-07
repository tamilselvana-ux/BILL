import multiprocessing
import os

port = os.environ.get('PORT', '8000')
bind = f"0.0.0.0:{port}"
# Keep workers low (2) so container stays well within 512MB RAM free-tier limits
workers = int(os.environ.get('GUNICORN_WORKERS', '2'))
threads = int(os.environ.get('GUNICORN_THREADS', '4'))
worker_class = 'gthread'
timeout = 120
keepalive = 5

accesslog = '-'
errorlog = '-'
loglevel = os.environ.get('GUNICORN_LOG_LEVEL', 'info')
