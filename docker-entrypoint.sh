#!/bin/bash
python $PROJECT_PATH/manage.py migrate

touch $LOGS_PATH/gunicorn.log
touch $LOGS_PATH/access.log

gunicorn $PROJECT_NAME.wsgi:application \
	--pythonpath $PROJECT_PATH \
	--name $PROJECT_NAME \
	--bind 0.0.0.0:80 \
	--workers 5 \
	--log-level=info \
	--log-file=$LOGS_PATH/gunicorn.log \
	--access-logfile=$LOGS_PATH/acces.log \
	"$@"