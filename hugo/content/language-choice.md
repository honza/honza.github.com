+++
title = "Language choice"
author = ["Honza Pokorny"]
date = 2015-11-02T11:25:00-04:00
categories = ["programming", "rant", "haskell", "go", "javascript"]
draft = false
+++

_Warning: this is a rant_

Recently, I have made great progress in my journey towards Haskell
enlightenment. I finally see how many of the little pieces of the Haskell
puzzle fit together. At this point, I feel empowered to go forth and write
useful programs. I [read](https://twitter.com/%5Fhonza/status/660421406698508288) through the source of [Scotty](https://github.com/scotty-web/scotty) the web framework
the other day, and I was very pleasantly surprised that I understood how it
works. I absolutely _love_ Haskell. I love that it makes you think. One does
not simply open a text editor and start banging at the keyboard to write a
Haskell program. I love that Haskell encourages generalizations and
abstractions. One of the biggest heureka moments in my journey was
understanding the full implications of why a function of type `a -> a` has a
single implementation. I'm addicted to running my program for the first time
(after fighting with the compiler for ages), and having it work. I think monad
transformers and lenses are really clever. By many criteria, Haskell is the
perfect programming language.

It has taken me four years to get here.

I used to get so discouraged that I took breaks for weeks or months at a time
because I didn't see the point of continuing. But I always came back. Now I
have finally arrived. I would say I'm an intermediate Haskeller. Naturally,
I'm thinking about writing some Haskell code at work which is going to be easy
given our service-oriented architecture.

I have also been playing with [Purescript](http://www.purescript.org/) which is a Haskell dialect that
compiles to javascript. In many ways, Purescript is a much better Haskell
because it doesn't come with the historical baggage. In speaking with my
colleague who doesn't know Purescript about introducing it into our code base,
I realized the gravity of what I was asking him to learn. It sounds great to
say "let's rewrite this in purescript" and expect someone to come back from
their weekend having learned enough to be dangerous when it took me four years
to learn.

Another great example is the open source community. If you choose Haskell for
your open source project, you might be productive, safe to refactor, write
little code --- but how many people will be willing to learn Haskell to
contribute a fix or a new feature?

Many of my Haskell friends like to mock the [Go](https://golang.org/) programming language. Myself
included at times. Mind you, the language is _objectively_ poorly designed.
The error handling, the lack of generics, the ridiculous package manager, the
absurd type system, the `range` thing, etc. It's almost exactly the opposite
of Haskell.

And yet, Go is a lot [more popular](http://adambard.com/blog/top-github-languages-2014/) than Haskell according to GitHub. Yet,
there are so many amazing projects written in Go, like Docker, Influxdb, etcd,
consul, prometheus, packer, and many more. Unlike Haskell, if you ask your
coworkers to learn Go over the weekend, everyone will come back with a little
app they built. A clearly inferior tool is used by crowds of people to build
cool things.

What should we conclude from this? The choice of programming language matters.
Programming is a social activity. Fewer features seems to equal easier to
learn. Generalization and programming language innovation seem to be out of
favor. Creating software to solve real problems with blunt tools seems to be a
lot more important than using a sharp axe. We'd much rather use an inferior
tool whose manual we don't have to read. We'd much rather snap a picture
with our smartphone than to learn how to use a DSLR.
