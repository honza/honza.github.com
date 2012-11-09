:title: How I use git
:date: 2012-05-11 12:30
:categories: git

How I use git
=============

Recently, I have noticed that there are quite a few wrappers around git to give
you a nicer interface to work with.  The new commands promise to be easy to
remember and make your life less frustrating.  I find these a little silly
because git on its own is a great tool.  Here I'm going to describe how I use
git to convince you (and myself) that it's not that hard.

Cloning
-------

This couldn't be any simpler:

::

    git clone git://github.com/honza/dotfiles.git


Committing
----------

Once I have cloned a repo, I start to make changes.  To see what files I have
changed, I run

::

    git status

Or to see what actual changes I made

::

    git diff

Then, when I'm ready to commit, I stage the files.  The index is one of my
favorite features of git.  It lets me decide what changes I want to commit.
Maybe I correct something as I work on something else.  Those things aren't
related so they shouldn't go into the same commit.  I grew up on Mercurial and
not having the index in Mercurial now really bothers me.

To stage all changed files, I do

::

    git add -u

If I decide that the changes I made are stupid and I want to get rid of them, I
do

::

    git checkout .

To make sure all staged changes are the right ones

::

    git diff --cached

Stashing
--------

I often stash my code.  Sometimes you need to look at some code in a different
branch, sometimes I notice something is broken and I want to see if I broke it
or not.

::

    git stash

will stash your changes.  To get it back I do

:: 

    git stash pop

And also, often I will see what I had stashed

::

    git stash list

Branches
--------

Creating new branches is simple and cheap

::

    git checkout -b new_branch

Delete a branch

::

    git branch -d branch_name

Or delete a branch on a remote server

::

    git push origin :branch_name


Rebasing
--------

I have `written <http://honza.ca/2011/05/the-importance-of-git-rebase>`_ on
rebasing before.  It makes your history much nicer.  Any time I pull code from
a remote repository, I do

::

    git pull --rebase

Or, if it's a specific branch

::

    git pull --rebase origin dev

Bisecting
---------

I *love* the bisect commnad in git.  You can use it to determine which commit
introduced a bug.  This is especially useful if you have a comprehensive test
suite.  For example, the latest commit is broken and you remember that all
tests where passing in version 1.2.  This example uses Django.

::

    git bisect start HEAD v1.2 --      # HEAD is bad, v1.2 is good
    git bisect run python manage.py test

Git will then keep running your tests until it finds the first commit that's
broken.

Merging
-------

When a feature branch is finished, I merge it into master with

::

    git checkout master
    git merge --no-ff feature

Viewing history
---------------

For viewing history, I really like the following command

::

    git log --pretty=format:"%h - %an, %ar : %s"'

This gives you the commit SHA, then the author's name, how long ago it was made
and a brief, one-line summary of the changes.  I have it aliased as ``gitl``.
I also use a simple graph to see the relationships between branches

::

    git log --oneline --graph

Upgrading all submodules in a project
-------------------------------------

This one is great, too.  I use it to upgrade all of my vim plugins.

::

    git submodule foreach git pull

Pulling and pushing
-------------------

This is pretty straight forward

::

    git pull
    git pull origin dev

    git push
    git push origin dev

Conclusion
----------

Once you learn what git calls what, it's pretty easy to just google the thing
you're trying to do.  I'm definitely not an expert but this gets me by.
