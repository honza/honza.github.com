+++
title = "How To Convert Vim Colorschemes To Pygments Themes"
author = ["Honza Pokorny"]
date = 2011-02-25T22:26:00-04:00
categories = ["code", "python", "vim"]
draft = false
+++

Recently, I have grown to love [Pygments](http://pygments.org). It gives you syntax
highlighting in the browser without heavy Javascript files. It supports just
about any programming language on the planet and it's just plain awesome. The
only thing that it's lacking is good color schemes. It comes with a dozen
themes that will certainly do the trick, but if you're used to looking at
pretty code in your favorite editor, the code examples on your website will
look a little dull.

I'm going to go out on a limb here and assume you have a favorite colorscheme.
I found a script that will turn a vim colorscheme into a Pygments theme. It
didn't work perfectly out of the box so I patched it. You can download it
[here](https://github.com/honza/vim2pygments). Copy your vim colorscheme to the same directory as the script and run
it like so:

```console
$ python vim2pygments.py molokai.vim > molokai.py
```

This will produce a Python file containing a simple style class that Pygments
can use. Next step is to download Pygments:

```console
$ hg clone http://dev.pocoo.org/hg/pygments-main pygments
```

And then you will install your new theme:

```console
$ cd pygments
$ cp ../molokai.py pygments/styles/molokai.py
```

OK, now for the fun part. We will use Pygments to generate the CSS file that
you will then use on your website:

```console
$ ./pygmentize -S molokai -f html -a .highlight > molokai.css
```

If you are a TextMate user, you might be able to get your favorite theme done,
too. A lot of popular Vim colorschemes are inspired by TextMate. Sunburst,
mustang and idle fingers come to mind. Just find a Vim version and you're good
to go.

That's it!
