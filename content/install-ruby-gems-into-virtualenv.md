+++
title = "Install Ruby gems into virtualenv"
author = ["Honza Pokorny"]
date = 2011-06-10T11:00:00-03:00
categories = ["python", "code", "virtualenv"]
draft = false
+++

You are a Python developer and every time you have to install a Ruby gem you
throw up in your mouth a little. Wouldn't it be nice if you could install Ruby
gems into your virtualenv? Yeah, it would.

Stick this in your virtualenv's `postactivate` script:

```bash
export GEM_HOME="$VIRTUAL_ENV/gems"
export GEM_PATH=""
export PATH=$PATH:"$GEM_HOME/bin"
```

That's it! You're welcome. :)

## Credit {#credit}

Give credit where credit is due. I stole this idea from [Idan Gazit](http://twitter.com/idangazit) and
made it better.
