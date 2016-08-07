FROM ubuntu:14.04

MAINTAINER Michael Henry Pantaleon  <me@iamkel.net>

ENV PROJECT_NAME django_project
ENV PROJECT_PATH /home/docker/projects
ENV LOGS_PATH $PROJECT_PATH/logs

RUN apt-get update && apt-get install -y \
	nginx \
	python \
	python-dev \
	python-setuptools \
  && rm -rf /var/lib/apt/lists/*

RUN easy_install pip
RUN pip install uwsgi
RUN pip install gunicorn

RUN echo "daemon off;" >> /etc/nginx/nginx.conf
COPY django_nginx.conf /etc/nginx/sites-available/default

WORKDIR $PROJECT_PATH
COPY requirements.txt $PROJECT_PATH

RUN pip install -r requirements.txt

RUN mkdir $LOGS_PATH
VOLUME ["$LOGS_PATH"]

COPY . $PROJECT_PATH

EXPOSE 80

# just create a project for test
RUN django-admin.py startproject $PROJECT_NAME $PROJECT_PATH

ENTRYPOINT ["docker-entrypoint.sh"]