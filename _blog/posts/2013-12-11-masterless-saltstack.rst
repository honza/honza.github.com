:title: Masterless Saltstack
:date: 2013-12-11 14:55
:categories: code, devops

Masterless Saltstack
====================

This is a simple guide on how to use Saltstack, the configuration manager, in
masterless mode.  In most scenarios, you will use a Saltstack master to
control many minions.  Saltstack contains a lot of utilities to check the state
of minions, gather information about them, etc.

However, if you are working on a small, single-server application, Saltstack's
master-minion setup might be overkill.  You can indeed use a single minion.

A bit of setup first
--------------------

Your project will need two directories for Saltstack's files.

::

    pillar/
    salt/

The ``salt`` directory will contain the scripts that are responsible for
setting up a particular part of your server, e.g. nginx, postgresql, etc.
``pillar`` on the other hand will contain the configuration value for each
environment that your app will run in.  So, you might have a *staging* and a
*production* environment set up there.

Each of these directories needs a ``top.sls`` file which is what's loaded
first.  For fun, let's just install ``vim`` into a production environment.

::

    pillar/
        top.sls
        production.sls
    salt/
        top.sls
        vim.sls

Salt
----

The ``salt/top.sls`` file will have a case-expression-like structure, matching
on hostnames of your app.


.. code-block:: yaml

    base:
        'production':
            - vim

Note that ``sls`` files use YAML syntax.

Here we are installing vim in the production hostname.

The ``salt/vim.sls`` file will look something like this:

.. code-block:: yaml

    vim:
        pkg:
            - installed

This simply says that we want the vim package installed.  Saltstack will
automatically detect your package manager (i.e. apt-get, yum, etc).

Pillar
------

The ``pillar/top.sls`` file has the same structure as the main file from the
salt directory.

.. code-block:: yaml

    base:
        'production':
            - production


When the ``production`` hostname is detected, use the ``production.sls`` file
for configuration.  You can put just about anything you want to the
``production.sls`` file, be it the servers IP address or the SMTP settings.

Where to put things
-------------------

After you've installed Saltstack on your server, you should copy or symlink the
``salt/`` and ``pillar/`` directories to the ``/srv`` directory

::

    /srv/salt
    /srv/pillar

Running it
----------

Once the configuration files are in place, you can run the minion's
provisioning command to get everything configured and installed.

::

    $ salt-call --local state.highstate

Don't ask me why it's like this.  Makes no sense.

Saltstack will run everything and then report what happened during the run.
