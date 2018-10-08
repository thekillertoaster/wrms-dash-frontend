#!/bin/bash

perl -pi -e 's/PUT_DB_PASS_HERE/'$(cat /opt/db/pgpass | tr -d '\n')'/' dashboard/settings.py

until ./manage.py makemigrations
do
    sleep 3
done
./manage.py migrate

gunicorn -w 4 --error-logfile - --log-level info -b 0.0.0.0:80 --env DJANGO_SETTINGS_MODULE=dashboard.settings dashboard.wsgi
