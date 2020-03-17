+++
title = "Building a Lisp to Javascript compiler"
author = ["Honza Pokorny"]
date = 2013-05-13T07:14:00-03:00
categories = ["compilers", "lisp", "javascript"]
draft = false
+++

In this post, I'm going to show you how I made a Lisp to Javascript compiler. I
really enjoy programming in Clojure but have often thought that the JVM isn't
always the best platform for scripts due to the slow JVM start-up. So, I
decided to implement a simple version of Clojure that compiles to Javascript
and can be run on top of nodejs.

Compilers are notoriously hard to understand and therefore make for great
mind-bending exercises.  Exactly my idea of weekend fun.


## What we are going to do {#what-we-are-going-to-do}

There are tons of Lisp to Javascript compilers out there.  What makes mine
special?  I'm using a PEG grammar to parse the source code.  Once it's parsed,
I turn the result into a [Parser API](https://developer.mozilla.org/en-US/docs/SpiderMonkey/Parser%5FAPI) compatible AST.  The AST is then passed
to [escodegen](https://github.com/Constellation/escodegen) which turns it into well-formatted Javascript.

This is great because I don't have to worry about the particulars of Javascript
syntax.  Escodegen takes care of inserting semicolons where appropriate, etc.
and everything looks clean and consistent.  It's nice because the parsing is
decoupled from the source code emission.  You can completely remove the
Javascript generation part and use some other software to do that.


## Lisp basics {#lisp-basics}

If you are familiar with Lisp, you can skip this section.

Lisp source code is made up of s-expressions.  An s-expression is a list whose
first element is a function and the rest are the arguments to that function.

```clojure
(greet "honza")
```

This is a list with two items.  `greet` is the name of the function and
`"honza"` is the argument.  In other languages, this might be represented as
`greet("honza")`.

Lisp uses s-expressions for everything, including function definitions, if
statements, assignments, binary expressions, etc.

```clojure
(def name "honza") ;; define a variable "name" and assign "honza" to it
(+ 1 2)            ;; add 1 and 2 and return the result

;; If the name variable is equal to "honza", print "hey honza", otherwise,
;; just print "hey stranger".

(if (= name "honza")
  (print "hey honza")
  (print "hey stranger"))

;; Function definition; it takes one parameter called "name".

(def greet
  (fn [name]
    (println "hello" name)))
```

In Lisp, a function body can have multiple s-expression but only the last one
is returned.  There is no `return` keyword in Lisp.  Binary operators and
things like the `if` keyword are actually functions that return values.


## The mighty PEG {#the-mighty-peg}

Every PEG grammar starts with the `program` directive.  This is where the
parser will start parsing.

```nil
program
  = s:sexp+ "\n"*  { return {
      type: 'Program',
      body: s
  };}
```

A Lisp program consists of one or more s-expressions, optionally followed by a
newline.  The list of one or more s-expressions is stored in the variable
`s`.  We then return a Javascript object with two properties: `type` and
`body`.  Since we are at the top level, we return it as a type of
`Program`, and our body will be made up of the matched s-expressions.  The
syntax is a little weird at first but you get used to it.  Fairly simple stuff.

If you tried to compile this grammar into a parser, it would fail because we
didn't tell it what an s-expression looks like.

```nil
sexp
  = _ a:atom _ { return a; }
  / _ l:list _ { return l; }
  / _ v:vector _ { return v; }
  / _ o:object _ { return o; }
```

OK, so an s-expression is either an atom, a list, a vector or an object.  Each
of these can be preceded and followed by any amount of whitespace.  Cool,
that's simple enough.  Except now we have to define what all those things are.

Let's start with the atom:

```nil
atom
  = d:[0-9]+ _ { return {type: 'Literal', value: numberify(d)}; }
  / '"' d:(!'"' sourcechar)* '"' _ { return {type: 'Literal', value: makeStr(d) }}
  / s:[-+/\*_<>=a-zA-Z\.!]+ _ { return {type: 'Identifier', name: s.join("")};}
```

So, an atom can be a list of one or more digits, a string or a valid
identifier.  In the digit directive, you will notice that we are assigning the
number to the `d` variable.  This will contain a list of all of the matched
numbers.  We then concatenate them and parse them into an integer.  That's what
the `numberify` function does.  A number or a string is a literal value so we
return it as such.  An identifier is a variable name, so we return it as such,
too.

Next up, vectors and objects:

```nil
vector
  = "[]" { return {type: 'ArrayExpression', elements: []}; }
  / _ "[" _ a:atom+ _ "]" _ { return {type: 'ArrayExpression', elements: a};}
  / _ "[" _ o:object+ _ "]" _ { return {type: 'ArrayExpression', elements: o};}

object
  = "{}" { return {type: 'ObjectExpression', properties: []}; }
  / _ "{" _ a:atom+ _ "}" _ { return makeObject(a); }
```

Continuing in the same vein, a vector is either an empty array, an array with
at least one atom in it, or an array with at least one object in it.

The `makeObject` function will take a pair by pair from the array and take
the first item in the pair and turn it into an object key and set as its value
to the second item in the pair.  If the number of elements in the array isn't
divisible by 2, it will yell at you.

Next up, lists.  Now, lists are special because the first item is the name of a
function.  This gives us the opportunity to define some built-in functions that
would otherwise be really tricky to define.

```nil
list
  = "()" { return []; }
  /  _ "(" _ s:sexp+ _ ")" _ {
    if (first(s).name === 'def') {
      return {
        type: 'VariableDeclaration',
        declarations: [{
          type: 'VariableDeclarator',
          id: s[1],
          init: s[2].expression? s[2].expression : s[2]
        }],
        kind: 'var'
      };
    }

    if (first(s).name === 'fn') {
      return {
        type: 'FunctionExpression',
        id: null,
        params: s[1].elements ? s[1].elements : s[1],
        body: {
          type: 'BlockStatement',
          body: init(rest(rest((s)))).concat(returnStatement(last(rest(s))))
        }
      };
    }

    if (Object.keys(builtins).indexOf(first(s).name) > -1) {
      return builtins[first(s).name](rest(s));
    }

    return processCallExpression(s);

  }
```

OK, there is quite a bit here, so let's step through it.  A list can be


### an empty list {#an-empty-list}


### a list of at least one s-expression {#a-list-of-at-least-one-s-expression}

If it's an empty list, we just return an empty array.  If it's a list of
s-expressions, we check for other things.  We look at the first element and see
what its name is.  It can be either:


### `def` - variable declaration {#def-variable-declaration}


### `fn` - an anonymous function {#fn-an-anonymous-function}


### a built-in function (`if`, `+`, `list`, etc.) {#a-built-in-function--if-plus-list-etc-dot}


### other function (user defined) {#other-function--user-defined}

The only thing left is the definition of whitespace

```nil
_
  = [\n, ]*
```

Zero or more of the following characters: newline, comma and space.


## Obstacles {#obstacles}

When converting the parsed source code to the Parser API tree, I hit a few
obstacles.  It turns out that Lisp and Javascript don't map perfectly to each
other and therefore some post-processing is needed.


### Statement vs expression {#statement-vs-expression}

In Lisp, everything is an expression.  In Javascript, there are both
expressions and statements.  The hardest part is the fact that a function call
can be both a statement and an expression depending on how it's used.  So you
can't represent it the same way every time.

I wrote a function that takes a list which represents an s-expression (the
first element is a function call, the rest are the parameters).

```javascript
function processCallExpression(s) {
  var callee = first(s),
      args = rest(s)

  args = map(function(s) {
    if (s.expression && s.expression.type === 'CallExpression') {
      return s.expression;
    } else {
      return s;
    }
  }, args);

  return {
    type: 'ExpressionStatement',
    expression: {
      type: 'CallExpression',
      callee: callee,
      'arguments': args
    }
  }

}
```

This will check if any of the arguments passed to the function are also
function calls.  If it's a nested function call, it's placed in the AST as a
`CallExpression`, otherwise it's a `CallExpression` inside a
`ExpressionStatement`.  The PEG parser can't detect this because it's context
free - each node only knows about itself.


### Implicit return {#implicit-return}

In Lisp, the last s-expression in a function's body is implicitly returned.
You don't need to denote this with a return statement, it's built-in.  Again,
we need to do some more processing.  If we are processing a function
declaration, we need to check its body and wrap the last expression in a
`ReturnStatement`.


### If is an expression in Lisp {#if-is-an-expression-in-lisp}

The if statement in Lisp is an expression, just like a function call or
anything else.  This means that the expression in any of the two branches is
effectively returned to the caller.  This means that we need to add an extra
wrapper around the statement and wrap each of the branch-expressions in a
return statement.

Like this:

```javascript
// this

if (n === 0) {
  return "it's zero";
} else {
  return "it's more than zero";
}

// becomes

(function() {
  if (n === 0) {
    return "it's zero";
  } else {
    return "it's more than zero";
  }
})();
```


## Standard library {#standard-library}

A lisp would be no fun without some fun functional programming functions.  I
have started working on a standard library for our lisp.  It lives in a file
called `lib.js`.  This file includes functions that are accessible from any
program that you write.

For example:

```javascript
function nth(list, n) {
    if (list.length && list.length + 1 < n) {
        return null;
    }

    return list[n];
}

function first(list) {
    return nth(list, 0);
}
```

And much more.


## Putting it all together {#putting-it-all-together}

Here is how it all comes together:


### Use peg.js to compile the grammar into a parser {#use-peg-dot-js-to-compile-the-grammar-into-a-parser}


### Take the parser and append to it the compiler program {#take-the-parser-and-append-to-it-the-compiler-program}

The compiler program is the command line utility that decides how your program
should be compiled, it parsers CLI flags, etc.  It can return the AST instead
of Javascript, it can uglify the resulting Javascript, etc.

You can use the result like so

```nil
$ ./inertia sample.clj
```

And it will print the resulting Javascript to stdout.  What the compiler
program will also do is prepend the compiled Javascript with the standard
library.  It simply reads the standard library code from the `lib.js` file
and prepends it.


## Conclusion {#conclusion}

This has certainly been a fun exercise for me.  You can check out the finished
product on [GitHub](https://github.com/honza/inertia).
