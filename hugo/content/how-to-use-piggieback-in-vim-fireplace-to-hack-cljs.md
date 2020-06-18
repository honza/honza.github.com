+++
title = "How to use piggieback in vim-fireplace to hack cljs"
author = ["Honza Pokorny"]
date = 2014-03-20T11:45:00-03:00
categories = ["vim", "clojure"]
draft = false
+++

(That's quite a title, isn't it?)

If you're using vim to write Clojure code, chances are that you're using Tim
Pope's vim-fireplace plugin. It's really great. It stars an nREPL session in
the background for you and lets you evaluate a form inside of vim. It's super
fast because it keeps the session around and it's one of my favorite things
about writing Clojure.

Recently, vim-fireplace received support for [piggieback](https://github.com/cemerick/piggieback). Piggieback is a
layer on top of nREPL that gives you support for ClojureScript. This is really
great because it gives you the ability to evaluate ClojureScript code in vim
just like your normal Clojure code.

Alright, here is how to set it up:

`project.clj`

```clojure
(defproject pig "0.1.0-SNAPSHOT"
  :description "FIXME: write this!"
  :url "http://example.com/FIXME"

  :dependencies [[org.clojure/clojure "1.5.1"]
                 [com.cemerick/piggieback "0.1.3"]]

  :plugins [[lein-cljsbuild "1.0.2"]]
  :repl-options {:nrepl-middleware [cemerick.piggieback/wrap-cljs-repl]}

  :source-paths ["src"]

  :cljsbuild {
    :builds [{:source-paths ["src"]
              :compiler {
                :target :nodejs
                :optimizations :simple}}]})
```

Pretty standard stuff. We're using the lein-cljsbuild plugin for automatic
compilation, we set up the source path and a nodejs compile target.

Now you simply open a `.cljs` file and you can do your usual vim-fireplace
magic. The first `cpr` (reload current buffer) command will connect to an
nREPL instance and initialize the piggieback wrapper.
