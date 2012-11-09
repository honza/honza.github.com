:title: Install Ruby gems into virtualenv
:date: 2011-06-10 11:00
:categories: Python, Code, virtualenv

Install Ruby gems into virtualenv
=================================

You are a Python developer and every time you have to install a Ruby gem you
throw up in your mouth a little. Wouldn't it be nice if you could install Ruby
gems into your virtualenv? Yeah, it would.

Stick this in your virtualenv's ``postactivate`` script:

.. code-block:: bash

    export GEM_HOME="$VIRTUAL_ENV/gems"
    export GEM_PATH=""
    export PATH=$PATH:"$GEM_HOME/bin"

That's it! You're welcome. :)

Credit
------

Give credit where credit is due. I stole this idea from `Idan Gazit`_ and
made it better.

.. _Idan Gazit: http://twitter.com/idangazit
