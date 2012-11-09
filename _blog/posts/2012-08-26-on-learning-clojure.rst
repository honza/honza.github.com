:title: On Learning Clojure
:date: 2012-08-26 22:45
:categories: code

On Learning Clojure
===================

Prefix notation
---------------

I'm a big fan of the prefix notation.  It makes everything appear the same
(if-statements, function calls , etc).  I like how it removes the need for
operator precedence rules.

All the parentheses
-------------------

Once you get into learning Clojure and you have written a small application,
you don't really see the parens anymore.  Sure, sometimes you still get the
*Unbalanced parens* error but those are easy to spot.  If you are afraid of
learning a LISP because of this, don't worry, you'll be fine.

JVM
---

Let's just say that the start-up time of the JVM isn't the fastest.  This makes
Clojure effectively useless for writing utility scripts.  However, the JVM is a
robust platform that runs your code really fast.  With Clojure, you get all the
benefits of the JVM: garbage collection, JIT, uberjars, etc.  Using Java
libraries in Clojure is usually pretty straightforward if you know the basics
of Java (but the code isn't the prettiest).  This is great because some of the
lower level stuff doesn't have to be reimplemented (think SHA1 digests,
sockets, etc).

Documentation
-------------

The language itself seems to be documented pretty well.  I haven't had any
issues when trying to find the signature for a built-in function.  However, the
community isn't exactly known for writing documentation.  Most of the time, you
find a library on Github and you are left to read the source.  If you are
lucky, you are told what to import and a few basic examples.  Good
documentation is something I take for granted coming from the Python world.

Libraries
---------

While you can certainly find a lot of good libraries for doing common things,
one area is still painful to develop for: the web.  Clojure still needs a
Django-like web framework that has all the batteries included.  Right now, the
only popular web framework is Noir and it's more like Sinatra or Flask.
Without a Django-like platform, you end up reinventing all the common things
for every application: authentication, form validation, ORM, etc.

Conclusion
----------

I really like the language.  I like the functional aspects of it and the
immutability.  I like lazy sequences and refs.  What I don't like is that the
community and the ecosystem is still a bit young and immature.  I find myself
waiting for stuff to happen before I can use this language more.
