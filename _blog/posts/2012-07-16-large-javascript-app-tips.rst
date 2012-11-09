:title: Large Javascript Application Tips
:date: 2012-07-16 08:13
:categories: Categories

Large Javascript Application Tips
=================================

This post isn't going to tell you that you should use MVC to structure your
application.  It isn't going to tell you which framework to use.  It's not
going to tell you to use CoffeeScript or MongoDB.  But I'm going to talk about
some small helpful things you can do to your Javascript application to make
easier to develop and maintain.

Naming Conventions
------------------

Improperly naming your variables, functions and classes can make it nearly
impossible to navigate large portions of existing code.  You have to follow the
chain all the way up where that variable was created (sometimes in a different
file) to see what type of value it holds.  By looking at a variable name, you
should be able to tell if it's a class definition or an instance.  You should
be able to distinguish between a constant and a function.

File dependency
---------------

Writing large Javascript applications for the browser is tricky because your
application needs to be split over multiple files and there doesn't seem to be
a good way to manage dependencies.  When you open up a file in your project,
you can't really know what Javascript code was loaded and executed before this
file.  Often times you find yourself looking at your build script or the
``head`` of your HTML document to see when this file is loaded in the grand
scheme of things.  In Python, you say ``from app import get_user`` to use a
function from a different file or module.  In the browser, you just don't.  I
find it useful to specify these kinds of dependencies at the top of each file
within a simple comment.

.. code-block:: javascript

    // maps.js
    // 
    // This file provides the ``Maps`` namespace.
    // It depends on jQuery and jquery.cookie.js.
    // It depends on the ``userId`` variable from the document.
    //
    // (function($) {
    //   ...


Class definition time and consumption time
------------------------------------------

There should be a clear distinction between when your classes are defined and
when they are consumed.  I like to prepare all my classes and functions
beforehand, and then kick off the app with a single call when the document is
ready.  It's nice to be able to tell that this is where the app starts.

Namespaces
----------

Your entire application should be contained within a namespace.  Putting all of
your code under a namespace makes it easy to tell where what function or class
definition is coming from.  It makes sure that you don't pollute the global
namespace.  It also allows you to select which functions and variables are
going to be exposed publicly.

Documentation
-------------

If your application isn't going to be open-source, you might be tempted to skip
writing documentation.  Adding a few comments here and there in the code can
help you quickly understand what is going on and where related code might live.
This also helps a lot when on-boarding new developers.  When a new member of
your team opens up an 800-line-of-code file with zero comments, they might
crawl under their desk and cry (I've wanted to do that a few times before).

Frameworks
----------

If you do decide to use a framework like Backbone.js, you should make sure that
you use it in a sane way.  When a new member joins your team, it's really nice
when you can point them to the framework's documentation and have them start
learning.  Obviously, you will want to do some custom things and maybe even
build extensions to the framework and that's fine as long as it's documented
and obvious.

Conclusion
----------

Thanks for listening
