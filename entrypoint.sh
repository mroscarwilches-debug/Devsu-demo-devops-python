#!/bin/sh
python manage.py migrate --noinput
exec gunicorn demo.wsgi:application --bind 0.0.0.0:8000 --workers 3
