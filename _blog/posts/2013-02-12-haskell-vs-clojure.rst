:title: Haskell vs Clojure syntax
:date: 2013-02-12 16:33
:categories: code, haskell, clojure, lisp

Haskell vs Clojure syntax
=========================

Clojure has virtually zero syntax.  What I mean by that is that all structures
look the same: the first item in a list is the function and the rest are the
arguments.  This is true for variable assignment, if statements, data
structures and functions themselves.

.. code-block:: clojure

    (+ 1 2)

    (defn greet [name]
      (str "Hello " name))

    (def user-count 334)

However, before you can do anything useful in Haskell, you must learn all kinds
of crazy syntax: function definitions, pattern matching, do forms, functors,
monads, typeclasses, ...


.. code-block:: haskell

    (*) <$> Just 2 <*> Just 8  

    Nothing >>= \x -> return (x*10)  

    instance Applicative Maybe where  
        pure = Just  
        Nothing <*> _ = Nothing  
        (Just f) <*> something = fmap f something  

This is why I find Haskell extremely hard to learn.  It's not because of
monads, recursion or functional programming concepts.  It's because of the huge
amount of special syntax.  And you need to learn a lot of it before you can do
something useful.
