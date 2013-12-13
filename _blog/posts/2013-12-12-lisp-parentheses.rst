:title: Lisp parentheses
:date: 2013-12-12 13:44
:categories: lisp

Lisp parentheses
================

Perhaps the number one reason why people are afraid to try Lisp or don't like
it is the huge amounts of parentheses cluttering up the code.  It's said to be
hard to read the code when it's full of parentheses.

Any experienced Lisp programmer will tell you that the parentheses disappear
fairly early on.  After a while, you hardly notice them as something annoying.
In fact, going back to C-family languages will make you feel like you need to
type all kinds of crazy punctuation.

While Clojure technically doesn't use significant whitespace like Python, in
reality, careful identation is crucial to writing clear code.

.. code-block:: clojure

    (defn crop-photo [user photo]
      (when (authenticated? user)
        (when (admin? user)
          (crop photo))))

In this snippet, there are four levels of indentation, four nested expressions.
It's easy to quickly scan this function guess what it does.  When a user is
authenticated and when they are an admin, crop the photo.  If any of the
``when`` expressions return a *falsy* value, the whole function will return
``nil``.  All of this is possible because Clojure uses prefix notation.  This
means that the first element in the ``(...)`` form is the name of the function.
Therefore, you only need to scan the beginnings of lines to see what functions
are being called.  Also, you never have to pay attention to closing parentheses
because they are all sitting together at the end of the function.

In Clojure, it's also idiomatic to put function arguments on new lines and
align them.

.. code-block:: clojure
    
    (or (admin? user)
        (staff? user))

In this example, the ``or`` macro usually takes two arguments.  We put each
argument on its own line and align them.  This way it's visually clear what the
code does.

Finally, when writing Clojure code, you rarely have to worry about matching up
your parentheses.  This is a job for your text editor.  Inserting a new
expression usually involves typing the ``(`` key and having its friend ``)``
inserted for you.
