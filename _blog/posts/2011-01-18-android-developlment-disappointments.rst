:title: Android Development disappointments
:date: 2011-01-18 18:23
:categories: Code, Java, Python

Android Development disappointments
===================================

The Android platform is the latest buzz in the smartphone world. I have
previously written on why I prefer Android over iPhone. In this article, we
will talk a little bit about what it's like to develop native applications for
Android.

Android SDK uses Java. I know Java but it's not my favorite. After working with
Python and Django for months, going back to Java isn't exactly easy. But it's
not undoable either.

Being from the Czech republic, I thought I would try to target the Czech
market. Android is starting to get really big over there. I decided to write a
simple news reader application for one of the leading news portals called iDnes
("eToday"). The application downloads an RSS feed, parses it and displays a
list of news articles to the user. The user has the option to choose their
topic, and to manually refresh the application to get new articles.

Not very complicated at all. It took me a few evenings to put it together. The
development process was quite fun. The Android SDK integration into Eclipse is
awesome. It tells you when you have to implement additional methods, or
automatically adds your imports when it's needed. As part of the SDK, you get a
simulator for all kinds of versions of Android (from 1.5 to 2.2). This way, you
can test your application on various versions of the API.

I read all the articles on packaging and distributing. I made sure my
application was backwards compatible. I tried to follow their guidelines for
app icons as much as I could (well, I suck at graphic design). I exported the
applications, signed it, aligned it and uploaded it to the Android Market.

I was excited. I did it. I published my first Android applications. But then
came the disappointment.

My app started to get a lot of bad comments in the market. People complained
that the application didn't do anything, and they couldn't read any news, etc.
I didn't come across any errors like that during testing. If the applications
doesn't have internet, it will tell the user it doesn't have internet. If there
is a problem, it will let them know.

As a developer and author, I feel there is no way for me to receive helpful
information about the errors the users are getting when they are interacting
with the application.

OK, that's it. If you have any comments or suggestions, do let me know in the
comments.

