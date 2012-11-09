:title: The importance of git rebase
:date: 2011-05-14 14:00
:categories: Code, Git

The importance of git rebase
============================

Git isn't just something you have to put up with when working with other
developers. Git is a wonderful tool that allows you to manage your code, its
evolution and help you recover from mistakes should they arise. One of the
things that people are intimidated by is ``git rebase``.

Let's look at an example. You're working on a team with two other developers.
You have a blessed repository that sits on your company's server. Everyone is
working on the same project but on slightly different tasks. Everyone is
working on the master branch. You write a bit of code here and there, you
commit a bunch of times and then it's time to share your code with the rest of
the team by pushing it up to the shared repository.

You run ``git push`` but receive an error saying that there are changes on the
server and your commit cannot be fast-forwarded. No big deal, right? You run
``git pull`` to download the changes that you don't have and automatically
merge your changes in. Then you can ``git push`` again and it will work just
fine.

The problem is that it makes the history of your project messy.

.. code-block:: console

    * 9:35 - Nancy - Merge branch 'master'
    |\
    * | 9:35 - Nancy - Second commit
    | |
    | * 9:30 - Brad - First commit
    |/
    * 9:12 - Nancy - First commit

As you can see, there is this strange **Merge branch 'master'** commit that's a
little out of place. If everyone on your team is regularly pushing to the
shared repository, the history gets littered with these weird commits pretty
quickly.

You may have guessed that there is a better way. We'll replay the above
scenario using ``git rebase``. Instead of running `git pull`, we will run ``git
pull --rebase``. What this will do is temporarily hide the commits that only you
have, then pull the changes from the remote repository, fast-forward (no merge
commit) and then re-apply your commits on top of the current HEAD. The end
result from a code point of view is the same, but the history is much cleaner:


.. code-block:: console

    * 9:35 - Nancy - Second commit
    * 9:30 - Brad - First commit
    * 9:12 - Nancy - First commit

See? Isn't this so much better? The only difference to your current workflow is
that instead of ``git pull`` you will run ``git pull --rebase``. Easy!
