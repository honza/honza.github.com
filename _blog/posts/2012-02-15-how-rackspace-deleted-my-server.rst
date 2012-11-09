:title: How Rackspace deleted my server
:date: 2012-02-15 08:00
:categories: Code

How Rackspace deleted my server
===============================

I have been with Rackspace for a while now and never had problems.  The server
has been fast and responsive and their prices are great.  However, what
happened yesterday blew my mind and totally made me change how I view server
providers as a whole---including the likes of AWS and Heroku.

Here is how it went down.

2:07pm CST
----------

I got an email from one of my administrators that the front end was
unreachable.  I immediately tried to visit the web application in my browser,
log into the machine via SSH and ping the server IP address.  All failed.  I
went on the Rackspace Cloud Server Live Chat to raise the issue with them.

2:48pm CST
----------

I was told to open a ticket through the admin console.  So I did and I handed
the ticket number to the operator who said they'd pass it on to operations.

5:05pm CST
----------

I got a reply on the ticket.  All it says is *we're working on it*.  At this
point, I'm freaking out because I have been down for over three hours.

6:00pm CST
----------

Still no word from Rackspace.  I got on the phone and explained the issue and
that I didn't feel it was being taken seriously.  The operator got the account
manager on the phone who in turn got a *tech guy* on the call.  They said that
the VM wasn't built properly when I first created it like 6 months ago and that
at that time it was queued up to be deleted and rebuilt.  It took this long to
finally come down the queue and actually get deleted.  They said they would
rebuild the server and let me keep the same IP and that I would get an email
with new credentials.

6:17pm CST
----------

I received said email and started to restore the server.  Luckily, I had a
working Chef script which made this very simple to do.  I think I was back
online in about 30 minutes.

Conclusion
----------

Everyone has been really nice and apologetic.  They even gave me a month's
credit to cover the damages.  I still think Rackspace is great but this whole
incident made me realize that anything can fail and that you should design your
application for easy recovery.  And test your backups!

