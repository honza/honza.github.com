:title: Why I love reStructuredText
:date: 2011-07-19 14:00
:categories: Code, RST

Why I love reStructuredText
===========================

A lot of geeks are using Markdown as their markup generation tool today. It's
simple, effective and used everywhere. It allows you to focus on your content
and not on the HTML code that will be used to display the content on a web
page. I have used Markdown extensively and its simplicity is appealing to me.

`reStructuredText`_ is similar to Markdown. If you know Markdown, it's dead
simple to learn to use RST. So, why bother? There are many things it can do
that Markdown simple wasn't designed to do.

Let me give you a bit of a background. As a programmer, I like to write and
save documents in text files, using the vim editor. This way I can easily keep
track of different versions of those documents and I will always be able to
open them. The problem is that most non-technical people, such as my family or
perhaps your clients, are trained to use Word documents or PDF files. Most
computer users wouldn't know what to do with that file and wouldn't understand
the syntax. I was looking for a way to write my documents in text files and
still be able to share those with others via Word/PDF. At first, I set up
simple LaTex templates. Then, I thought about writing a script to parse
Markdown files to PDF via ReportLab. All very cumbersome and not quite right.

Then, I dicovered RST. It's written in Python which means that any
customizations won't be impossible. When I installed it, I was surprised that
it came with a set of command line tools to parse RST files to other common
formats such as:

* HTML
* PDF via Latex
* ODT (OpenOffice format)

I played around a bit with the tools and found them useful, but not great. The
default formatting was ugly and it seemed like it would take too much work to
manually edit the embedded CSS/Latex/ODT styles.

I read through the documentation more and found out that you can set up global
or project specific configuration files that RST parsers will look for by
default. The syntax is simple and effective. This way, you only set up your
styles once and then all you have to do to convert those styles is

.. code-block:: console

    $ rst2html.py doc.rst > doc.html

RST is extensible and you can configure it to do almost anything you want. Once
good example is Pygments syntax highlighting. You can add a new directive and
automatically run your code examples through Pygments. Or, you can customize
the LaTex writer to use a specific font, page size and lots more.

.. _reStructuredText: http://docutils.sourceforge.net/
