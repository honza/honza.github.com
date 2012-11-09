:title: Mutt sidebar labels
:date: 2012-10-30 06:28
:categories: mutt

Mutt sidebar labels
===================

The sidebar in Mutt is useful if you have multiple email accounts and want to
switch between them quickly.  It shows you each inbox with a number of unread
emails.  I have 6 Gmail accounts plugged into my Mutt and here is what I used
to see.

::

    INBOX (1)
    INBOX
    INBOX (2)
    INBOX (1)
    INBOX (7)
    INBOX

And I had to remember which one was which.  Let's say you have your mailboxes
in ``~/.mail``.

::

    $ ls ~/.mail
    work home

Create a directory called ``aliases`` and symlink the inboxes to that
directory:

::

    $ ln -s ~/.mail/work/INBOX ~/.mail/alias/work
    $ ln -s ~/.mail/home/INBOX ~/.mail/alias/home

Then, point your Mutt sidebar config at those.  When you open Mutt the next
time, it should look like this

::

    work (1)
    home (8)

That's much more useful than just a list of ``INBOX`` things.
