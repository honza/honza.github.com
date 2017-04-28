:title: Should I finally drop QWERTY?
:date: 2017-04-28 10:00
:categories:

Should I finally drop QWERTY?
=============================

For years now, I have wanted to switch my keyboard layout from QWERTY to
something more ergonomic.  QWERTY was `designed`_ to prevent typewriters from
jamming.  Modern computers don't have this problem.  So, why are we still using
QWERTY?

So, for me, it's a given that I should switch to something else.  But what?  The
Dvorak layout is the obvious choice.  Most people who switch from QWERTY end up
using Dvorak.  Then there is Programmer Dvorak, and Colemak, and Programmer
Colemak, and hosts of others.

There are `websites`_ that allow you analyze some text, and help you determine
which layout is best for you.  This is of limited utility because the text you
past in won't be representative of your actually habits.

Getting down to business
------------------------

So, how can I hack this?  I installed a `keylogger`_ on my laptop, and
collected data for many days.  Then, I wrote a little script to analyze the
data.  This is mostly because analysis websites won't let you paste in more
than a few kilobytes of text.  The most basic measure of how good a keyboard
layout is is the percentage of keystrokes that are on the home row.  The idea
is that if you have to move your fingers less, you will be faster, less tired,
and experience less pain.

The script takes the output of the keylogger and gives you percentages of
keystrokes that are on the home row for each layout.  Here is what I got:

::

    qwerty: 38.69149%
    colemak: 35.601215%
    dvorak-programmer: 34.441067%
    dvorak: 34.441067%

Wait, what?  QWERTY is the most optimal keyboard layout for me?  That can't be
right.  Surely, there must be a bug in my code somewhere.  I went over
everything several times, tested my functions with dummy data, and so on.
Everything seems to be correct.  You can head over to `GitHub`_ and prove me
wrong.

I have been thinking about why I got this bizarre result.  I think it's because
most of my regular typing isn't necessarily writing prose.  There is a lot of
vim-style navigation (in `Spacemacs`_, in the `browser`_, etc), I use `i3`_ as
my window manager, ...  A lot of it is running commands, tab-completing things,
keyboard shortcuts.  Other layouts, like Colemak, are probably optimized for
long-form writing.  In those cases, it would probably win.  But for
programmer-centric typing, QWERTY is likely to be king because everything is
optimized for it.

What do you think?

.. _designed: http://discovermagazine.com/1997/apr/thecurseofqwerty1099
.. _websites: http://patorjk.com/keyboard-layout-analyzer/#/main
.. _keylogger: https://github.com/kernc/logkeys
.. _GitHub: https://github.com/honza/keylogger
.. _Spacemacs: https://github.com/syl20bnr/spacemacs
.. _browser: https://vimium.github.io/
.. _i3: https://i3wm.org/
