+++
title = "Haskell Strings"
author = ["Honza Pokorny"]
date = 2012-10-24T10:01:00-03:00
categories = ["haskell", "code"]
draft = false
+++

It continues to amaze me how bad Haskell is at processing strings.  One of the
reasons I wanted to learn Haskell was to be able to write short,
dynamic-language-like programs that execute fast once compiled.  Somehow
rather, Haskell has failed to deliver on its promise of _bare metal_ speed.  I
mostly write scripts and utilities meant to run on my machine---these scripts
mostly process text.  Read a file, parse it and spit something out.


## Example {#example}

Let's build a simple program that will show what I'm talking about.


### Read a file called `file` which contains prose {#read-a-file-called-file-which-contains-prose}


### Capitalize every word in that body of text {#capitalize-every-word-in-that-body-of-text}


### Print the result to stdout {#print-the-result-to-stdout}

We will be testing our programs with a file with about 1.2 million lines of
Lorem Ipsum.  This file is around 75MB.

Here is attemp number one.  This is really simple Haskell.

```haskell
-- Normal.hs

module Main where
import Data.Char

convert :: String -> String
convert = unlines . (map convertLine) . lines

convertLine :: String -> String
convertLine = unwords . (map convertWord) . words

convertWord :: String -> String
convertWord s = (toUpper (head s)):(tail s)

main = do
    name <- readFile "file"
    putStr $ convert name
```

Compile and execute with

```nil
ghc -O2 -o normal Normal.hs
time ./normal > /dev/null
```

This takes about 17 seconds.  Let's see if we can do any better.  When you
complain about Strings in Haskell being slow on some neckbeard forum, people
will tell you to use `Data.Text`.

```haskell
-- Main.hs

module Main where

import Data.Char
import qualified Data.Text as T
import qualified Data.Text.IO as X

convert :: T.Text -> T.Text
convert = T.unlines . (map convertLine) . T.lines

convertLine :: T.Text -> T.Text
convertLine = T.unwords . (map convertWord) . T.words

convertWord :: T.Text -> T.Text
convertWord s = T.cons (toUpper (T.head s)) (T.tail s)

main = do
    name <- X.readFile "file"
    X.putStr $ convert name
```

This is mostly the same as above.  Instead of using the `String` type to work
with text, we use the `Data.Text.Text` type.

```nil
ghc -O2 -o main Main.hs
time ./main > /dev/null
```

How did it do?  One entire minute, that's 5 times slower.  And it uses obscene
amounts of memory (around 600MB on my machine).  Let's use lazy IO when reading
the file, maybe it will improve.

```haskell
-- change this
import qualified Data.Text as T
import qualified Data.Text.IO as X

-- to this
import qualified Data.Text.Lazy as T
import qualified Data.Text.Lazy.IO as X
```

This clocks in at 27 seconds.  Much better than the non-lazy version.  Next
thing to try is to ignore unicode and go for the ultimate, bare-metal speed.
Let's use `ByteString` instead of `Text`.

```haskell
module Byte where

import Data.Char
import qualified Data.ByteString as B
import qualified Data.ByteString.Char8 as C

convert :: B.ByteString -> B.ByteString
convert = C.unlines . (map convertLine) . C.lines

convertLine :: B.ByteString -> B.ByteString
convertLine = C.unwords . (map convertWord) . C.words

convertWord :: B.ByteString -> B.ByteString
convertWord s = C.cons (toUpper (C.head s)) (C.tail s)

main = do
    name <- B.readFile "file"
    B.putStr $ convert name
```

Hm, not that much better.  27 seconds.  That's about as good as the lazy
version when using `Text`.  Let's see if we can squeeze more perfomance out
of this with a lazy `ByteString`

```haskell
-- change this
import qualified Data.ByteString as B
import qualified Data.ByteString.Char8 as C

-- to this
import qualified Data.ByteString.Lazy as B
import qualified Data.ByteString.Lazy.Char8 as C
```

This takes about 10 seconds.  Awesome.  This is the best I can do with Haskell.
10 seconds to process 1.2 million lines of text.  I guess that's not too bad.

<strong>EDIT</strong>: Someone [pointed out on Reddit](http://www.reddit.com/r/haskell/comments/120h6i/why%5Fis%5Fthis%5Fsimple%5Ftext%5Fprocessing%5Fprogram%5Fso/c6r6rm1) that this whole thing can be
accomplished as a simple one-liner.  This is actually a pretty elegant
solution.

```haskell
module Main where

import Data.Char
import qualified Data.Text.Lazy as T
import qualified Data.Text.Lazy.IO as X

convert :: T.Text -> T.Text
convert = T.tail . T.scanl (\a b -> if isSpace a then toUpper b else b) ' '

main = do
    name <- X.readFile "file"
    X.putStr $ convert name
```

This clocks in at 8.5 seconds.  Not bad at all.

<strong>EDIT 5</strong>: Someone pointed out that I didn't include a version of the
one-liner that uses `ByteString`.

```haskell
module Main where

import Data.Char
import qualified Data.ByteString.Char8 as T

convert :: T.ByteString -> T.ByteString
convert = T.tail . T.scanl (\a b -> if isSpace a then toUpper b else b) ' '

main = do
name <- T.readFile "file"
T.putStr $ convert name
```

This clocks in at 3.5s on my machine.  Pretty fast!


## Python {#python}

Let's try this in Python

```python
def process(data):
    lines = data.split('\n')
    return "\n".join([process_line(line) for line in lines])


def process_line(line):
    words = line.split(' ')
    new = [w.capitalize() for w in words]
    return " ".join(new)


if __name__ == '__main__':
    data = open('file').read()
    print process(data)
```

Execute with

```nil
$ time python main.py > /dev/null
```

Six seconds!  Six!  How can a dynamic language be so much faster than compiled
Haskell?

<strong>EDIT 4</strong>: There has been some discussion on Reddit about being able to
accomplish this task in only one line in Haskell.  It's actually possible in
Python, too.

```python
print open('file').read().title()
```

This clocks in at 2 seconds.


## Javascript and V8 {#javascript-and-v8}

```javascript
// main.js

var fs = require('fs');

function capitalize(string) {
    return string.charAt(0).toUpperCase() + string.slice(1);
}

function processLine(line) {
    var words = line.split(' ');
    for (var i=0; i < words.length; i++) {
        words[i] = capitalize(words[i]);
    }

    return words.join(' ');
}

function run() {
    var data = fs.readFileSync('file', 'utf-8');
    var lines = data.split('\n');

    for (var i=0; i < lines.length; i++) {
        lines[i] = processLine(lines[i]);
    }

    return lines.join("\n");
}

console.log(run());
```

Execute it with:

```nil
$ time node main.js > /dev/null
```

Wait for it!  4.5 seconds.  I have no words.


## How about Go? {#how-about-go}

<strong>EDIT 3</strong>: (Add this section.  Looks like this post is turning into a language
shootout, le sigh).

```go
package main

import (
    "fmt"
    "io/ioutil"
    "bytes"
)

func main() {
    body, _ := ioutil.ReadFile("file")
    result := bytes.Title(body)
    fmt.Printf("%s", result)
}
```

Put this into `title.go`, compile and run with

```nil
$ go build title.go
$ time ./title > /dev/null
```

This is around 2 seconds.  Pretty crazy performance.  Only twice the time
compared to C.


## How about C? {#how-about-c}

<strong>EDIT 2</strong>: (Add this section)

[Andrew Stewart](https://twitter.com/andrewstwrt) has graciously written a C version of this program.  Like he
[said](https://twitter.com/andrewstwrt/status/261282584263286784), you should do all of your scripting in C.

```c
// script.c

#include <stdio.h>
#include <string.h>

int main(void) {
    static const char filename[] = "file";
    FILE *file = fopen(filename, "r");

    if (file != NULL) {
        char line[1024];
        while(fgets(line, sizeof line, file) != NULL) {
        line[strcspn (line, "\n")] = '\0';

        int lengthOfLine = strlen(line);
        int word = 0;
        int i;

        for (i = 0; i < lengthOfLine; i++) {
            if (isalpha(line[i])) {
            if (!word) {
                line[i] = (char) toupper (line[i]);
                word = 1;
            }
            } else {
            word = 0;
            }
        }

        printf ("%s\n", line);
        }

        fclose(file);
    } else {
        perror(filename);
    }

    return 0;
}
```

Compile and run this with:

```nil
$ gcc -o script script.c
$ time ./script > /dev/null
```

Of course, this is ripping fast.  It takes about 1 second (1.05-1.15, never
below 1).


## Recap {#recap}

```nil
Haskell - String              17s
Haskell - Text                60s
Haskell - Text (Lazy)         27s
Haskell - ByteString          27s
Haskell - ByteString (Lazy)   10s
Haskell - Text, scanl (Lazy)  8.5s
Haskell - ByteString, scanl   3.5s

Python -                      6s
Python - One line, titl()     2s

Javascript & V8               4.5s

Go                            2s

C                             1s
```

Not sure if I want to continue learning Haskell after this.
