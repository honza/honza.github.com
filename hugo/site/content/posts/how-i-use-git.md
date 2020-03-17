+++
title = "How I use git"
author = ["Honza Pokorny"]
date = 2012-05-11T12:30:00-03:00
categories = ["git"]
draft = false
+++

Recently, I have noticed that there are quite a few wrappers around git to give
you a nicer interface to work with.  The new commands promise to be easy to
remember and make your life less frustrating.  I find these a little silly
because git on its own is a great tool.  Here I'm going to describe how I use
git to convince you (and myself) that it's not that hard.


## Cloning {#cloning}

This couldn't be any simpler:

```nil
git clone git://github.com/honza/dotfiles.git
```


## Committing {#committing}

Once I have cloned a repo, I start to make changes.  To see what files I have
changed, I run

```nil
git status
```

Or to see what actual changes I made

```nil
git diff
```

Then, when I'm ready to commit, I stage the files.  The index is one of my
favorite features of git.  It lets me decide what changes I want to commit.
Maybe I correct something as I work on something else.  Those things aren't
related so they shouldn't go into the same commit.  I grew up on Mercurial and
not having the index in Mercurial now really bothers me.

To stage all changed files, I do

```nil
git add -u
```

If I decide that the changes I made are stupid and I want to get rid of them, I
do

```nil
git checkout .
```

To make sure all staged changes are the right ones

```nil
git diff --cached
```


## Stashing {#stashing}

I often stash my code.  Sometimes you need to look at some code in a different
branch, sometimes I notice something is broken and I want to see if I broke it
or not.

```nil
git stash
```

will stash your changes.  To get it back I do

```nil
git stash pop
```

And also, often I will see what I had stashed

```nil
git stash list
```


## Branches {#branches}

Creating new branches is simple and cheap

```nil
git checkout -b new_branch
```

Delete a branch

```nil
git branch -d branch_name
```

Or delete a branch on a remote server

```nil
git push origin :branch_name
```


## Rebasing {#rebasing}

I have [written](http://honza.ca/2011/05/the-importance-of-git-rebase) on
rebasing before.  It makes your history much nicer.  Any time I pull code from
a remote repository, I do

```nil
git pull --rebase
```

Or, if it's a specific branch

```nil
git pull --rebase origin dev
```


## Bisecting {#bisecting}

I _love_ the bisect commnad in git.  You can use it to determine which commit
introduced a bug.  This is especially useful if you have a comprehensive test
suite.  For example, the latest commit is broken and you remember that all
tests where passing in version 1.2.  This example uses Django.

```nil
git bisect start HEAD v1.2 --      # HEAD is bad, v1.2 is good
git bisect run python manage.py test
```

Git will then keep running your tests until it finds the first commit that's
broken.


## Merging {#merging}

When a feature branch is finished, I merge it into master with

```nil
git checkout master
git merge --no-ff feature
```


## Viewing history {#viewing-history}

For viewing history, I really like the following command

```nil
git log --pretty=format:"%h - %an, %ar : %s"'
```

This gives you the commit SHA, then the author's name, how long ago it was made
and a brief, one-line summary of the changes.  I have it aliased as `gitl`.
I also use a simple graph to see the relationships between branches

```nil
git log --oneline --graph
```


## Upgrading all submodules in a project {#upgrading-all-submodules-in-a-project}

This one is great, too.  I use it to upgrade all of my vim plugins.

```nil
git submodule foreach git pull
```


## Pulling and pushing {#pulling-and-pushing}

This is pretty straight forward

```nil
git pull
git pull origin dev

git push
git push origin dev
```


## Conclusion {#conclusion}

Once you learn what git calls what, it's pretty easy to just google the thing
you're trying to do.  I'm definitely not an expert but this gets me by.
