:title: Virtual machines for Django developers
:date: 2011-04-19 12:00
:categories: Code, Django

Virtual machines for Django developers
======================================

`Vagrant`_ is a tool for building and distributing virtualized
development environments. It's based on VirtualBox VMs. This article describes
how this Ruby tool can be useful to Django developers.

Why vagrant?
------------

The modern web developer works on many different projects. Each project has a
unique set of requirements, dependencies and package versions needed for that
project to succeed. Keeping all of these libraries in check is difficult.
``virtualenv`` is a tool that creates isolated environments for Python
packages. Vagrant takes this approach a step further. You can virtualize the
entire server.

Just as each Django project will have a ``requirements.txt`` file which lists
the project's ``pip`` dependencies, your project will now have a
``Vagrantfile`` and a ``cookbooks`` directory. The ``Vagrantfile`` describes
how the VM should be created and the ``cookbooks`` directory contains
instructions on what packages to install. For example, in the ``Vagrantfile``
you will specify a VM which runs an Ubuntu server with 256MB of RAM and your
``cookbooks`` directory will tell vagrant to install apache2, git, postgresql
and memcached.

Getting started with vagrant is simple.

Getting started
---------------

vagrant is distributed as a Ruby gem and you can install it like so:

.. code-block:: console

    gem install vagrant

Next, you will download a base box that I made for you. It's an Ubuntu 10.10
server with minimal configuration.

.. code-block:: console

    vagrant box add vagrant-ubuntu http://honza.ca/downloads/vagrant-ubuntu.box

This will take a while so you may want to get a beverage.

Next, you will create a directory that will hold your project and initialize it
for vagrant.

.. code-block:: console

    cd ~/Code
    mkdir webapp
    cd webapp
    vagrant init vagrant-ubuntu

This will create a ``Vagrantfile`` in that directory.

And then run

.. code-block:: console

    vagrant up

to actually build and boot the environment. This might take a few minutes.

After this, your environment is running. Your environment is a headless
virtualbox instance.  You can ``ssh`` into the box by running:

.. code-block:: console

    vagrant ssh

You will notice that your project directory (``webapp``) is mounted inside the
environment under ``/vagrant``. Any changes to either directory will affect the
other.

You can shutdown your environment with 
    
.. code-block:: console

    vagrant halt

Destroy it with:

.. code-block:: console

    vagrant destroy

Provisioning
------------

Next, you will install some packages into the VM. You will install some common
Django packages: PostreSQL, Apache, WSGI, memcached and git.

.. code-block:: console

    cd ~/Code/webapp
    git clone git@github.com:honza/cookbooks.git

This downloads all kinds of cookbooks ready for our use. We will create a
custom cookbook inside that directory where we will define what packages we
want:

.. code-block:: console

    cd cookbooks
    mkdir webapp
    cd webapp
    mkdir recipes
    touch recipes/default.rb

Now open up the ``default.rb`` file and enter the following:

.. code-block:: ruby

    require_recipe "postgresql::server"
    require_recipe "apache2"
    include_recipe "apache2::#{node[:django][:web_server]}"
    require_recipe "git"
    require_recipe "memcached"

And modify your ``Vagrantfile`` to use the cookbooks:

.. code-block:: ruby

    Vagrant::Config.run do |config|
      config.vm.box = "vagrant-ubuntu"
        config.vm.provision :chef_solo do |chef|
          chef.cookbooks_path = "cookbooks"
          chef.add_recipe "webapp"
        end
    end

For the configuration changes to take effect, you need to run:

.. code-block:: console

    vagrant reload

OK, that concludes our quick introduction to Vagrant. I hope you see how this
can be beneficial and how simple it is to get started.

.. _Vagrant: http://vagrantup.com
