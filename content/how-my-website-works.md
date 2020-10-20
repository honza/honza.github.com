+++
title = "How My Website Works"
author = ["Honza Pokorny"]
date = 2011-01-22T21:18:00-04:00
categories = ["code", "python"]
draft = false
+++

I'm sure you've heard of static site generators like Jekyll (Ruby) or Hyde
(Python). The benefits are obvious - your site is hosted on a cheap shared
hosting and it can easily survive the Digg/Slashdot/Reddit effect. There is no
database latency - the browser requests a file on the server and gets it back
immediately.


## Update (2011-02-27): {#update--2011-02-27}

While I still use a static generator to power my site, it's not a different
engine. I got tired of launching a django server just to write a post. I wrote
a new static site generator called [Socrates](https://github.com/honza/socrates). Each post is now a separate
file written in Markdown. Socrates then runs through those files and creates a
site for me. I'm still using django templates. What follows is the original
post.


## django {#django}

The site is a simple django blog. There is nothing really of note when it comes
to django-specific coding. I run the django server locally when I'm editing or
adding articles. It provides a nice UI. It also lets me easily preview the site
without generating anything.


## static generator {#static-generator}

When I'm happy with the state of the website and want to publish it, I run the
static generator. It's contained in the `generate.py` file. It runs through
all possible urls and for each one it generates a static file. Each file is a
complete HTML page that the user's browser will download. The folder structure
is as follows:

```bash
/2010/
    /02/
        post-one.html
        post-two.html
/2011/
    ..
        ..
/about/
    index.html
index.html
/page/
    /2/
        index.html
/category/
    /android/
        index.html
    /code/
        index.html
    ..
```

You get the idea. This way, with an `.htaccess` file we can have the
following URL structure:

```bash
/2010/02/post-one/
```


## FTP deploy script {#ftp-deploy-script}

And the final piece is the `deploy.py` script. It looks at the deploy
directory, and with a little help from git, it figures out what files were
changed since the last deploy. It then takes those files and throws them up on
the server. A normal shared hosting.


## Conclusion {#conclusion}

You can check out the code on [Github](https://github.com/honza/honza.github.com).
