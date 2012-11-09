:title: Google APIs - Y U NO WORK
:date: 2011-09-13 21:00
:categories: code, google


Google APIs - Y U NO WORK
=========================

Recently, at `SheepDogInc`_, I have been working with various Google APIs,
especially the Calendar API. The state of these APIs is rather *unfortunate*.
Google is a web giant and you'd think that their APIs would be state-of-the-art
given the number of professionals they employ. 

Documentation
-------------

Before we go anywhere, let me just talk about the documentation for a minute.
As an open-source software author and advocate, I always encourage developers
to write extensive and good documentation. Somehow, Google didn't get the demo.
Most of their documentation is sparse, incorrect and out-of-date. If you would
like to know what data a call returns, you're better off just making the call
and inspecting the response. This will actually save you time because the docs
are probably wrong anyway.

Reliability
-----------

Google is like the master of scalability. They have an estimated one million
servers world-wide. And yet, they cannot consistently return a 200 to an API
call. I have written horrible, horrible glue code and hacky workarounds to
account for this unpredictability. Sometimes you will get a response, sometimes
it will timeout, sometime you will get a 404...

Engineering 
-----------

With all these amazing engineers, can Google really not make a better API?
Honestly, if I was in a position to hire a person who worked on the Google API
team, I would think twice. Seriously --- test your app, keep your docs
up-to-date, and mainly, stop pissing me off!


.. _SheepDogInc: http://www.sheepdoginc.ca
