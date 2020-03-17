+++
title = "JSLint syntax checker for vim   :@code:@vim:@open-source:"
author = ["Honza Pokorny"]
date = 2011-04-05T09:00:00-03:00
draft = false
+++

Douglas Crockford's [JSLint](http://www.jslint.com/) script is almost a golden standard when it comes
to checking the syntax and general sanity of your javascript files. Being lazy
by nature, I got tired of copying and pasting my code into the web form.

I wanted to be able to run the JSLint tool from the command line. JSLint itself
is written in javascript. It's a 6000-line beast. How do you run a javascript
library as a command line utility? The answer is [node.js](http://nodejs.org/).

I wrote a quick little script that takes a single argument (your file) and runs
JSLint over it, printing any errors to the console. I call it `jslintnode.js`
and the code is on [Github](https://github.com/honza/jslintnode.js).

Well, checking my files from the command line is certainly better than using
the web interface. But I still have to run it over and over. As you may know,
I'm fanatical [vim](http://www.vim.org) user. There is a cool plugin called [syntastic](https://github.com/scrooloose/syntastic) which
runs through the file you are editing each time you save it. It puts little
`>>>` characters next to the line you are editing which tells you that you
screwed up and need to fix that line.

However, by default, syntastic uses the `jsl` utility to check javascript
files. With a little bit of work, you can modify the original script to use our
`jslintnode.js` utility.

Go into the `/syntax_checkers/` directory and open up the `javascript.vim`
file.

Change this line:

```vim
if !executable('jsl')
```

to this:

```vim
if !executable('jslintnode.js')
```

And replace the body of the `SyntaxCheckers_javascript_GetLocList()` function
with the following:

```vim
let makeprg = "jslintnode.js ".shellescape(expand('%'))
let errorformat='%W%f(%l): lint warning: %m,%-Z%p^,%W%f(%l): warning: %m,%-Z%p^,%E%f(%l): SyntaxError: %m,%-Z%p^,%-G'
return SyntasticMake({ 'makeprg': makeprg, 'errorformat': errorformat })
```

Save and restart vim.

That's it. Now as you're editing any javascript files you will get instant
feedback as to the quality of your code as judged by JSLint. And remember that
_JSLint will hurt your feelings_.
