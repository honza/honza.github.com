+++
title = "Using Chef with small Django apps"
author = ["Honza Pokorny"]
date = 2011-09-20T20:00:00-03:00
categories = ["django", "chef", "python", "code"]
draft = false
+++

This year at [DjangoCon](http://djangocon.us), it seemed like everybody was talking about automatic
deployments and namely [Chef](http://www.opscode.com/chef/). After coming home from the conference, I spent
a considerable amount of time learning chef and thinking about how it can be
best used with small to medium size Django apps. In this post, I will walk you
through how Chef works and how it can help you make awesome web apps.

When I say small apps, I mean single-server deployments. This means that your
web server, your database, memcached, rabbitmq, etc is installed on a single
Ubuntu VM. When learning Chef, I found that most of the available tutorials
focus on multi-server setups and are too complex for ordinary apps.

Unfortunately, Chef is written in Ruby and it can be a little tricky to debug
since all the tracebacks are meaningless to a Python developer. However, don't
despair, you can usually tell pretty quickly what's going on. To test your
deployment, we will be using [Vagrant](http://vagrantup.com) which is an awesome tool for running
virtual machines on your development machine.

## What we will install {#what-we-will-install}

Our Django application will be deployed using the following:

### nginx {#nginx}

### gunicorn {#gunicorn}

### postgresql {#postgresql}

### memcached {#memcached}

### rabbitmq {#rabbitmq}

### git {#git}

Your development machine will need to have [Fabric](http://docs.fabfile.org/en/1.2.2/index.html) installed.

## How Chef works {#how-chef-works}

Chef is a tool that is installed on your server. You give it a bunch
configuration files and tell it to provision server with the necessary packages
and settings. This means that our automatic deployment will have to parts: Chef
configuration files for the sever, and several Fabric tasks to install Chef
remotely and start the provisioning process.

So, to configure Chef, we will create a _deploy_ directory inside our project's
repository. I like to keep the following structure:

```console
$ ls -a
.git coolapp docs deploy README.md Vagrantfile fabfile.py
```

... where _coolapp_ is your Django project. We will focus on the _deploy_
directory and the _fabfile_. Chef is a cook how prepares your server for
dinner. So, Chef needs some cookbooks and recipes. Each cookbook is a directory
that contains various configuration files for a specific application that you
want installed. So for example, you will have a _PostgreSQL cookbook_ and a
_nginx cookbook_. The deploy directory will contain a directory called
_cookbooks_ which will contain all other cookbooks. Now, the good news is that
you don't have to make the cookbooks yourself. [Opscode](http://www.opscode.com), the company behind
Chef, maintains a large selection of cookbooks on [Github](https://github.com/opscode/cookbooks). You can copy and
paste the cookbooks you need for you project. We will need the following:

### build-essential (for building from source) {#build-essential--for-building-from-source}

### erlang (rabbitmq depends on this) {#erlang--rabbitmq-depends-on-this}

### git {#git}

### memcached {#memcached}

### nginx {#nginx}

### postgresql {#postgresql}

### python (for virtualenv and python header files) {#python--for-virtualenv-and-python-header-files}

### rabbitmq {#rabbitmq}

## Cookbooks {#cookbooks}

Each cookbook contains a _recipes_ directory. Each recipe tells Chef how this
particular application is to be installed and configured. For example, it will
tell nginx to create an entry in _sites-available_ and _sites-enabled_. Or, it
will restart PostreSQL when it's done being installed.

There is also a _files_ directory and a _templates_ directory. Templates are
Ruby templates which define a particular configuration file. For example, in
order for Chef to be able to properly configure nginx with the proper server
name, it needs to know on what domain your application will be hosted. More on
this later, but there is a master file which has all your settings in it and
Chef reads from that and substitutes the necessary values. The _files_
directory contains files that need no further modification and can be copied
over verbatim.

## node.json {#node-dot-json}

The _node.json_ file is a per project file that specifies certain values for
Chef to use. For example, you can tell Chef what you want your PostgreSQL
database to be called, what the name of your django project is, etc. It has a
simple JSON syntax.

## Your app's recipe {#your-app-s-recipe}

Your application is going to need a simple recipe. This means creating a
cookbook bearing your project's name and creating a _recipes_ directory within
in. The recipe should be called _default.rb_ and all it needs to include is a
list of applications to install. For example:

```ruby
# Example django app cookbook

execute "Update apt repos" do
    command "apt-get update"
end

include_recipe 'nginx'
include_recipe 'build-essential'
include_recipe 'python'
include_recipe 'postgresql::server'
include_recipe 'memcached'
include_recipe 'runit'
include_recipe 'git'

execute "restart postgres" do
    command "sudo /etc/init.d/postgresql-8.4 restart"
end

execute "create-database" do
    command "createdb -U postgres -O postgres #{node[:dbname]}"
end
```

You can see it's pretty simple. We update Ubuntu's repositories, include some
recipes, restart PostgreSQL and create a new database.

## Start the engines {#start-the-engines}

At this point, you can try out your configuration with Vagrant. To help you
out, I have create a [template](https://github.com/honza/django-chef) project on Github that you can download and
use out of the box.

The next big part is writing the Fabric scripts. You will want the following
tasks:

### Install Chef {#install-chef}

### Transfer the cookbooks directory to the server {#transfer-the-cookbooks-directory-to-the-server}

### <dl class="docutils"> {#dl-class-docutils}

<dt>Bootstrap the Django project</dt>
<dd>\*\*\* Moving code to the server

### Creating a virtualenv {#creating-a-virtualenv}

### Installing requirements {#installing-requirements}

### Syncing the database {#syncing-the-database}

### Running migrations {#running-migrations}

### Starting gunicorn {#starting-gunicorn}

</dd>
</dl>

### Deploy {#deploy}

You can see how I implemented mine [here](https://github.com/honza/django-chef/blob/master/fabfile.py). I recommend that you use Fabric's
_roledefs_ which will allow you to specify vagrant as the host:

```console
$ fab -R vagrant bootstrap
```

## The real thing {#the-real-thing}

Once you've tested your application in Vagrant so you are ready to deploy to a
server. All that's left to do is create a new _roledef_ in the _fabfile_ and
run it!

## Conclusion {#conclusion}

I am by no means a Chef expert---I learned how to use it a few days ago. If you
have any feedback, do let me know.
