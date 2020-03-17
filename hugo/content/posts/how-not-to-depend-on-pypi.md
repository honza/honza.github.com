+++
title = "How not to depend on PyPI"
author = ["Honza Pokorny"]
date = 2012-02-04T20:00:00-04:00
categories = ["code", "django", "python"]
draft = false
+++

When deploying a Django application, you often use a `requirements.txt` file
that contains a list of the application's dependencies. During deployment, your
provisioning system will `pip install` all of those to make sure that your
application runs as desired.

The format of a typical `requirements.txt` files isn't unlike the following

```nil
django==1.3.1
psycopg2==2.4.4
Fabric==1.3.3
...
```

By default, `pip` will go to the [Python Package Index](http://pypi.python.org) (PyPI) and look for
that package there.

Unfortunately, PyPI has been known to be down or slow at times; and you want
your deployments to be as smooth as possible.


## What you can do {#what-you-can-do}

Instead of depending on PyPI for a production application, you can host the
packages that your application needs yourself. It's actually surpringly easy to
do. Your existing deployment strategy can easily be modified to remove the
dependency.

First, we will create a freeze of your requirements. This will look into your
environment and figure out which version of which package you will need for the
production environment.

```nil
$ pip freeze -r requirements.txt > freeze.txt
```

Once you have the list of packages, you can tell `pip` to download all the
packages into a directory without installing them.

```nil
$ pip install -d pypi -r freeze.txt
```

This will download all packages from `freeze.txt` into the `pypi/`
directory.

The next step is to upload all these packages to a publicly accessible server
that can serve static files. This can anything from S3, Cloudfiles or even
Github pages. I like to place all of these packages into a `packages/`
directory. You will also need a simple index file to go with your packages. All
the index file needs to is provide a list of HTML links to those packages. The
index will be used by `pip` to locate the package source distribution.

I have put together a simple Fabric task that will read the contents of the
`pypi/` directory and create this index file for you.

```python
def make_index():
    result = local('ls pypi', capture=True)
    packages = result.split('\n')

    html = "<html><head></head><body>%s</body></html>"

    links = []

    for package in packages:
        link = '<a href="packages/%s">%s</a>' % (package, package)
        links.append(link)

    links = '\n'.join(links)

    f = open('index.html', 'w')
    f.write(html % links)
    f.close()
```

Upload the index file to your server and you're ready to deploy. Instead of the
usual:

```nil
$ pip install -r requirements.txt
```

You will run this:

```nil
$ pip install -r freeze.txt -f http://yourPypiHost.com/index.html --no-index
```

This will completely ignore PyPI and only use your index when locating
packages. This way your deploys will be faster and more reliable.
