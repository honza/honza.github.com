:title: When HN gets in the way
:date: 2013-07-13 22:06
:categories: code

When HN gets in the way
=======================

Reading stuff online can become addictive.  So addictive, in fact, that it can
negatively affect your productivity as a programmer.  Most of us go to Hacker
News or Reddit to get our dose of news.  We justify it by saying that it's
*research* or that we are *trying to stay current in the community*.  Whatever
your excuse, you know you have a problem when you check Hacker News every ten
minutes just to see if anything new and awesome has been added.

    "Close Hacker News and open a f***ing book."
    -- Steve Losh in this `talk`_.

.. _talk: http://devslovebacon.com/conferences/bacon-2012/talks/eve-working-around-evolution

Maybe you have already gotten over the initial self-denial and you have added
some entries to your ``/etc/hosts`` file to keep yourself from constantly going
to those sites.  That's all well and good but I think we can do better.

You've already opened the tab and you are now staring at a blank error page.
Why not put something more useful there?

Me, I like to learn new things.  There are way too many things I'd like to
learn.  Why not show a list of things I'd like to learn and allow me to click
through to the website?

I have installed nginx on my machine and set up a simple static page with a few
links things like *Learn You a Haskell for Great Good* or Steve Losh's *Learn
Vimscript the Hardway*.  Now every time I go to HN, I see those links and am
reminded that I wanted to spend some time learning those things...

.. image:: /media/hn_nginx.png

Steps
-----

Install nginx.  ``brew install nginx`` or ``sudo apt-get install nginx`` or
whatever might apply to you.

Stick this in your ``nginx.conf``:

::

    worker_processes  1;

    http {
        include       mime.types;
        default_type  application/octet-stream;

        keepalive_timeout  65;

        server {
            listen       443;
            server_name  news.ycombinator.com;

            ssl                  on;
            ssl_certificate      /usr/local/etc/nginx/server.crt;
            ssl_certificate_key  /usr/local/etc/nginx/server.key;

            location / {
                root   html;
                index  index.html index.htm;
            }
        }

        server {
            listen       80;
            server_name  reddit.com;

            location / {
                root   html;
                index  index.html index.htm;
            }
        }

    }

If any of the sites you are blocking are served over SSL, you will need to get
a self-signed certificate.  This is a one time setup and doesn't really take
that long to do.

::

    $ openssl req -new -x509 -nodes -out server.crt -keyout server.key
    $ chmod 600 server.key

Now you just place those two files to the locations referenced in the above
``nginx.conf`` file and restart nginx.

And here is how you can make Chrome stop complaining about your self-signed
certificate (source_).

.. _source: http://www.robpeck.com/2010/10/google-chrome-mac-os-x-and-self-signed-ssl-certificates/

1.  In the address bar, click the little lock with the X. This will bring up a
    small information screen. Click the button that says "Certificate
    Information."

2.  Click and drag the image to your desktop. It looks like a little
    certificate.

3.  Double-click it. This will bring up the Keychain Access utility. Enter your
    password to unlock it.

4.  Be sure you add the certificate to the System keychain, not the login
    keychain. Click "Always Trust," even though this doesn't seem to do
    anything.

5.  After it has been added, double-click it. You may have to authenticate
    again. Expand the "Trust" section.

6.  "When using this certificate," set to "Always Trust"

7.  That's it! Close Keychain Access and restart Chrome, and your self-signed
    certificate should be recognized now by the browser.

Conclusion
----------

Hopefully, this will be helpful to you and nudge you every now and then to
learn something you've been putting off.
