+++
title = "Posterous-style Blogging On App Engine"
author = ["Honza Pokorny"]
date = 2010-07-07T22:00:00-03:00
categories = ["appengine", "code", "python"]
draft = false
+++

Posterous has been getting a lot of attention lately. Its simplicity appeals to
a wide range of users and more and more users are switching over from other
well-established blogging platforms such as Blogger or WordPress. In this
article, we will have a look at how you can replicate the Posterous
functionality on App Engine.

In case you don't know what Posterous is, it's very simple. It's a blogging
tool like Google's Bloggeror Wordpress.com. What makes it different from the
other services is its ridiculous simplicity. With Posterous, you don't need to
create an account. That's because you create new posts by emailing your post to
Posterous. It creates links for you, images sent as attachments will be
transformed into galleries, etc.

I like Posterous, but my website has a lot of custom programming on the
back-end so I'm very hesitant to switch over. And besides, I like to know how
things work behind the scenes. I thought it might be fun to create a system
similar to Posterous' for my own blog which is, of course, hosted on App
Engine.

Here is what we are going to do. I want to be able to send an email to my own
blog and have it turn it into a post and publish it to the blog.

OK, let's start with the post model:

```python
class Post(db.Model):
    title = db.StringProperty()
    body = db.TextProperty()
    added = db.DateTimeProperty(auto_now_add=True)
    author = db.StringProperty()
```

Very straight forward. You have your title, body, author and when the post was
published.

In order to enable incoming email, you need to add a couple of lines of code to
your `app.yaml` file. In addition to your regular handlers, add the
following:

```yaml
inbound_services:
  - mail

handlers:
  - url: /_ah/mail/.+
    script: main.py
```

The first line enables incoming email for your application. The second part is
the important part. On App Engine, an incoming email message is processed as a
HTTP POST request. Since it's a regular HTTP request, we will need a handler
for it in the `app.yaml` file. You have several options here. You can create
a catch-all handler for all incoming email addresses (like I've done above), or
create seperate handlers for different addresses.

The email address that we will use is in the following format:
[your_string@appid.appspotmail.com](mailto:your%5Fstring@appid.appspotmail.com). You should substitute the appid with your
app's ID. The string before the '@' symbol can be set to anything you want.

With this out of the way, we are ready to write the actual email handler. This
will go into your `main.py` file which you defined in the `app.yaml`.

First, some imports:

```python
import email
from google.appengine.ext.webapp.mail_handlers import InboundMailHandler
```

Then, you add the following to the list of URL mappings in the instantiation of
the application class.

```python
application = webapp.WSGIApplication([
    ('/', Index),
    EmailHandler.mapping()
    ], debug=True)
```

Here EmailHandler is the request handler class that will handle the incoming
email. The `mapping()` method will map all of the addresses and send all of
them to this handler class. It's just a convenience method, no magic here.

Now, finally, onto the actual handler:

```python
class EmailHandler(InboundMailHandler):
    def receive(self, mail_message):
        post = Post()
        post.title = mail_message.subject
        for content_type, body in mail_message.bodies():
            post.body = body.decode()
        post.author = 'John Smith'
        post.put()
```

This is actually very simple. The incoming email message is saved in the
`mail_message` variable and you can access all of the usual email metadata as
its properties (e.g. mail_message.sender). So, we create a new post, take the
email's subject and set it as the post's title. The `bodies()` method
extracts the body of the email and the `decode()` function will decode the
actual body. Then we set the author and save the post in the datastore.

Often you will want to include a link in your post, or create a list. This is
easily accomplished with HTML tags. However, HTML tags are a pain, so you might
want to use something like Markdown.

Adding markdown support is super easy. Download the Python
[Markdown library](http://code.google.com/p/python-markdown2/) and put the `markdown2.py` file in your app's root
directory. Then import it in your `main.py` file.

```python
import markdown2
```

And change the following line:

```python
post.body = body.decode()
```

to this:

```python
post.body = markdown2.markdown(body.decode())
```

And that's it!

## Conclusion {#conclusion}

This is a very simple yet effective technique and it will allow you to create
post from anywhere. I hope you've enjoyed the post. Let me know if you have any
suggestions on how to improve it.

## Code {#code}

The complete code for this app is available on [Github](https://github.com/honza/Posterous-App-Engine).
