+++
title = "Deploying Django with nginx and gunicorn"
author = ["Honza Pokorny"]
date = 2011-05-30T09:15:00-03:00
categories = ["code", "python", "django"]
draft = false
+++

The amazing Django [documentation](https://docs.djangoproject.com/en/1.3/howto/deployment/modwsgi/) recommends that you use Apache and modwsgi
to deploy your webapp. While this is certainly not bad advice, you may not want
to use Apache after all. Apache is a beast that eats up a lot of memory, is
kind of slow and can't handle as much traffic. As a fun alternative, I would
like to talk about deploying Django on nginx using the [gunicorn](http://gunicorn.org/) web server.

Just a quick note before we start: this isn't an out-there deployment option. I
spoke to one of the gunicorn developers and was told that every django hosting
company (think ep.io) uses this setup.

## Get your server ready {#get-your-server-ready}

I use Rackspace for small, single server web apps. I created an Ubuntu 10.10
instance with 256MB of RAM. Then, I created a user for my app and added my ssh
key to `authorized_keys`. Basic stuff.

## Install nginx {#install-nginx}

Installing nginx couldn't be simpler. Latest stable release is provided via a
ppa repository.

```console
$ sudo apt-get install python-software-properties -y
$ sudo -s
$ apt-add-repository ppa:nginx/stable
$ apt-get update
$ apt-get install nginx
$ exit
```

## Project structure {#project-structure}

The user under which the app will run is `webapp`, so I checkout my app in
`/home/webapp`.

```console
/home/webapp/app
/home/webapp/app/static
/home/webapp/env
```

Note that I'm using `virtualenv` to deploy this app.

## Configure nginx and gunicorn {#configure-nginx-and-gunicorn}

The following two files can be distributed with your project.

nginx.conf:

```console
server {
    listen 80;
    server_name webapp.org;

    access_log /home/webapp/access.log;
    error_log /home/webapp/error.log;

    location /static {
        root /home/webapp/app;
    }

    location / {
        proxy_pass http://127.0.0.1:8888;
    }
}
```

Next, I symlinked `nginx.conf` to the server's `sites-enabled` directory.

```console
$ sudo ln -s /home/webapp/app/nginx.conf /etc/nginx/sites-enable/webapp.org
```

This sets up nginx to directly serve the applications's static files (css, js,
etc.). Everything else is proxied to the gunicorn server.

Now gunicorn is a Python HTTP server. It's super simple and effective. I
installed it into the app's environment.

```console
$ (env) pip install gunicorn
```

gunicorn.conf.py:

```python
bind = "127.0.0.1:8888"
logfile = "/home/webapp/gunicorn.log"
workers = 3
```

That's it! The config files are simple and easy to read.

## Running {#running}

I then collected all the static files into the `static` directory:

```console
$ (env) python manage.py collectstatic
```

I restarted nginx:

```console
$ sudo /etc/init.d/nginx restart
```

And finally, I ran the `gunicorn` server:

```console
$ (env) cd /home/webapp/app
$ (env) gunicorn_django -D -c gunicorn.conf.py
```

And I was good to go.

## Notes {#notes}

You may have to change the permissions on the `static` directory. Also, the
command above starts `gunicorn` as a deamon - a better way would be to use a
monitoring service to start it. Think `runit` or `supervisord`. Also, I
didn't include any database specific configurations since that's indentical to
an Apache deployment.
