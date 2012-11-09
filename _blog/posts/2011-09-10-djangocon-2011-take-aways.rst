:title: DjangoCon 2011 Take-Aways
:date: 2011-09-10 21:30
:categories: code, django

DjangoCon 2011 Take-Aways
=========================

My employer, `SheepDogInc`_, sent me and a colleague of mine to `DjangoCon
2011`_. It was my first developer conference and I had a blast. Here a few
quick points about what the conference has clarified for me.

Deploying Django
----------------

Despite the Django official documentation's recommendation to use Apache and
mod_wsgi, most people seem to deploy Django with nginx and gunicorn. This has
been a pleasant surprise to me because I like it but though that it was too
simple (or less robust than Apache).

Provisioning servers
--------------------

It seemed that everybody was talking about `Chef`_ and automatic deployments.
Instead of manually connecting to a server via ssh, you can run one command
which will install all the necessary packages for your application (nginx,
postgresql, etc) and configure them. It makes the whole process less
error-prone. Also, you're more likely to spin up a new VM on your development
machine to try things out because you don't have to thing about setting it up.
Especially with tools like `vagrant`_, it's dead easy.

Pronouncing things
------------------

When you read names of technical products, you can't always be sure how it's
supposed to be pronounced.

* PyPI: pie-pee-eye
* PyPy: pie-pie
* wsgi: wizz-gy
* nginx: engine-x


Did you go to DjangoCon 2011? What are your thoughts?

.. _SheepDogInc: http://www.sheepdoginc.ca/
.. _DjangoCon 2011: http://djangocon.us/
.. _Chef: http://www.opscode.com/chef/
.. _vagrant: http://vagrantup.com/
