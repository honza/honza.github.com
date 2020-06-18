+++
title = "How to compile vim"
author = ["Honza Pokorny"]
date = 2013-07-18T10:16:00-03:00
categories = ["code"]
draft = false
+++

... from source when you're using the homebrew-provided Python.

If you have installed Python via homebrew, your vim will compile fine but when
a plugin tries to use Python to do some its work, vim will crash like this:

![](/images/vim-crash.png)Not pretty.

Apparently, this is because vim will use the first Python it can find which in
our case the homebrew-provided one. You can of course get a pre-compiled
version and ignore this. But I like to use the latest version of vim and with
the 7.4 beta, I have been doing that a lot lately...

So, what is one to do? We have to fix the `PATH`. Here is the script that I
use to recompile vim. This goes in the root of the vim project.

```bash
export PATH=/bin:/usr/sbin:/sbin:/usr/bin

./configure \
        --enable-perlinterp \
        --enable-pythoninterp \
        --enable-rubyinterp \
        --enable-cscope \
        --with-features=huge

make
```

There and vim is now compiled properly with Python support that won't make you
cry.

Thanks to Steve Losh for pointing me in the right direction on this.
