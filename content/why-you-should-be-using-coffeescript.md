+++
title = "Why you should be using CoffeeScript"
author = ["Honza Pokorny"]
date = 2011-04-11T16:45:00-03:00
categories = ["code", "javascript"]
draft = false
+++

I'm sure you've heard of CoffeeScript. Everyone is talking about it, it seems.
It's a beautiful language with a simple syntax that you use to write
Javascript. CoffeeScript compiles to Javascript. Here is why I think you should
be using it:


## Readability {#readability}

CoffeeScript is designed to be beautiful and readable. There is no unnecessary
fluff. Less syntax boilerplate, fewer mistakes. Compare:

```javascript
// regular javascript
var author = "William Shakespeare";
// coffeescript
author = "William Shakespeare"
```

Indentation is also important in CoffeeScript - just like in Python. This makes
closures and blocks easier to spot.


## Valid Code {#valid-code}

There are many different coding styles when it comes to writing Javascript. The
good thing about CoffeeScript is that the Javascript it generates is valid - it
passes [Javascript Lint](http://www.javascriptlint.com/). And if your code isn't valid CoffeeScript, it
won't compile. It's a win-win. This is perhaps my favorite feature.


## Easy class inheritance {#easy-class-inheritance}

This is just great. It reminds me of Python and Ruby:

```coffeescript
class Animal
    constructor: (@name) ->

    move: (meters) ->
        alert @name + " moved #{meters}m."

class Dog extends Animal
    move: ->
        alert "Whoof..."
        super 5
```

Compiles to this in Javascript:

```javascript
var Animal, Dog;
var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
    for (var key in parent) {
        if (__hasProp.call(parent, key)) child[key] = parent[key];
    }
    function ctor() { this.constructor = child; }
    ctor.prototype = parent.prototype;
    child.prototype = new ctor;
    child.__super__ = parent.prototype;
    return child;
};
Animal = (function() {
    function Animal(name) {
        this.name = name;
    }
    Animal.prototype.move = function(meters) {
        return alert(this.name + (" moved " + meters + "m."));
    };
    return Animal;
})();
Dog = (function() {
    function Dog() {
        Dog.__super__.constructor.apply(this, arguments);
    }
    __extends(Dog, Animal);
    Dog.prototype.move = function() {
        alert("Whoof...");
        return
        Dog.__super__.move.call(this, 5);
    };
    return Dog;
})();
```

Quite a difference, huh? Think how much time you'd need to understand each
version and make any changes required. In my mind, this encourages better code
organization and structure.


## Node.js awesomeness {#node-dot-js-awesomeness}

CoffeeScript comes with a Node.js utility, `coffee`. You can write your
Node.js code in CoffeeScript and run it with `coffee file.js`. The utility
wraps the CoffeeScript compiler and the `node` executable. This way, you can
whip up a quick server in no time. Genius.


## Easy debugging {#easy-debugging}

With tools like [Google Web Toolkit](http://code.google.com/webtoolkit/), your code compiles to _minified_
javascript. Non-minified code is obviously easier (possible?) to read and debug.
