+++
title = "Internal Clojure libraries"
author = ["Honza Pokorny"]
date = 2015-11-06T06:32:00-04:00
categories = ["clojure"]
draft = false
+++

At work, we have a few Clojure services in production.  Each service is its own
leiningen project with its own dependencies.  And because setting up a local
maven repository is hard, each project reimplements quite a bit of logic.  This
duplicate code usually relates to the non-essential but still important parts
of a service: logging, metrics, sentry integration, etc.

Just the other day, I was getting really annoyed with this situation, and was
about ready to go learn about the wonderful intricacies of Maven, when I
discovered leiningen's `install` command.

With `lein install`, you can install your library as a jar and a pom to the
local repository.  Here, local repository means a local repository, typically
in `~/.m2`.  Your apps can then depend on this library via the normal
`:dependencies` list in the project file.  This is all completely seamless
and works well.

Apparently, this command has been around for a long time.

Armed with this new information, I was able to create an internal project
called _metrics_ and remove a ton of duplication.  `lein install` also allows
multiple versions of the same library to be installed at once.  Simply require
whatever version you need in your apps' `project.clj` file.

This makes developing Clojure projects without having to publish your libraries
to Clojars a lot easier.
