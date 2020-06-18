+++
title = "The importance of git rebase"
author = ["Honza Pokorny"]
date = 2011-05-14T14:00:00-03:00
categories = ["code", "git"]
draft = false
+++

Git isn't just something you have to put up with when working with other
developers. Git is a wonderful tool that allows you to manage your code, its
evolution and help you recover from mistakes should they arise. One of the
things that people are intimidated by is `git rebase`.

Let's look at an example. You're working on a team with two other developers.
You have a blessed repository that sits on your company's server. Everyone is
working on the same project but on slightly different tasks. Everyone is
working on the master branch. You write a bit of code here and there, you
commit a bunch of times and then it's time to share your code with the rest of
the team by pushing it up to the shared repository.

You run `git push` but receive an error saying that there are changes on the
server and your commit cannot be fast-forwarded. No big deal, right? You run
`git pull` to download the changes that you don't have and automatically
merge your changes in. Then you can `git push` again and it will work just
fine.

The problem is that it makes the history of your project messy.

\#+BEGIN_SRC console
