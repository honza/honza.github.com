+++
title = "Remap CapsLock to something useful"
author = ["Honza Pokorny"]
date = 2012-02-07T09:30:00-04:00
categories = ["code"]
draft = false
+++

Arguably, CapsLock is [the most useless key](http://capsoff.org/) on your keyboard. I honestly
can't remember the last time I had a real use for it. If are a programmer, you
should remap it to something more useful. The rest of this post will describe
how to remap your CapsLock on a Mac OSX installation.


## What we are going to do {#what-we-are-going-to-do}

I'm a heavy vim user and reaching for the Esc key all the is a pain. We will
remap the CapsLock to Esc. However, I want to be able to use it for something
else if I'm not in vim. We will set it up so that when you hit CapsLock on its
own, it will send Esc. However, if you hold CapsLock and press another key, it
will send Ctrl. That way you can do things like Ctrl+F, etc.

On Mac OSX, you will want to do use [Karabiner](https://pqrs.org/osx/karabiner/). It's an excellent
piece of software that will allow you to take control of your keyboard.


## Settings {#settings}

Once you have installed KeyRemap4MacBook, go to System Preferences and select
the Keyboard submenu. Hit the Modifier Keys button and remap CapsLock to Ctrl.
You will have to do this once for every keyboard that you use.

Next, head over to the KeyRemap4MacBook settings. The magical setting you are
looking for is

```nil
Control_L to Control_L
    (+ When you type Control_L only, send Escape)
```

That's it!
