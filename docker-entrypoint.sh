#!/bin/bash
python $PROJECT_PATH/manage.py migrate

/etc/init.d/nginx restart

gunicorn $PROJECT_NAME.wsgi:application \
	--bind unix:/tmp/gunicorn.sock \
	--workers 5 \
	--log-level=info \
	--log-file=/tmp/gunicorn.log \
	--access-logfile=$LOGS_PATH/acces.log \
	"$@"