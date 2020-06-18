+++
title = "Building a Redis clone in Haskell"
author = ["Honza Pokorny"]
date = 2015-09-03T12:00:00-03:00
categories = ["haskell", "code"]
draft = false
+++

In this post, we will attempt to make a simplified clone of [Redis](http://redis.io) in Haskell.
Here is a set of requirements that we will aim to fullfill:

### `get` and `set` operations {#get-and-set-operations}

### Multi-threaded {#multi-threaded}

### Atomic {#atomic}

### Redis compatible (implement the Redis protocol) {#redis-compatible--implement-the-redis-protocol}

We should be able to use the `redis-cli` tool to connect to our server and
issue commands to it.

We are going to omit many features that Redis has. For example, there will be
no disk persistence. We will accomplish this with about 100 lines of Haskell.

## Getting started: stack {#getting-started-stack}

We are going to use [stack](https://github.com/commercialhaskell/stack) to build our project. Stack is a new build tool for
Haskell projects. We can also use it to create all the necessary files that
make up a Haskell project. You can find the installation [instructions](https://github.com/commercialhaskell/stack/wiki/Downloads) here.

Let's create our project. We will call our server _Redish_.

```nil
$ stack new Redish simple
```

This will create a directory `Redish/` with a few files in it.

```nil
Redish/
    LICENSE
    README.md
    Redish.cabal
    Setup.hs
    src/
        Main.hs
    stack.yaml
```

You can use stack to build this project and run it:

```nil
$ stack build
Redish-0.1.0.0: configure
Configuring Redish-0.1.0.0...
Redish-0.1.0.0: build
Preprocessing executable 'Redish' for Redish-0.1.0.0...
[1 of 1] Compiling Main             ( src/Main.hs, .stack-work/dist/x86_64-osx/Cabal-1.22.4.0/build/Redish/Redish-tmp/Main.o )
Linking .stack-work/dist/x86_64-osx/Cabal-1.22.4.0/build/Redish/Redish ...
Reidhs-0.1.0.0: install
Installing executable(s) in
/Users/<user>/<dirs>/Redish/.stack-work/install/x86_64-osx/lts-3.2/7.10.2/bin
$ stack exec Redish
hello world
```

## Types {#types}

Let's start by defining our types. Redish is an in-memory database so we will
need a representation of our database. For a simple key-value store, all that
we need is a simple map. Let's create a few aliases.

```haskell
type Value = ByteString
type Key   = ByteString
type DB    = Map Key Value
```

Next, we will need to represent the commands that our server knows how to
handle. The command data structure can be a `get`, a `set` or unknown.

```haskell
data Command = Get Key
             | Set Key Value
             | Unknown
             deriving (Eq, Show)
```

## Software transactional memory {#software-transactional-memory}

Now that we have our types in places, we need to write a few functions to
operate on them. We need a way to insert data and to query our database.

First things first though. Since by default everything in Haskell is immutable,
how can we change the value of our in-memory database? We can't simply
overwrite the old value with the new one. The compiler won't let us. The
answer is software transactional memory, or STM for short.

STM allows us to atomically change a value in our program. The atomic part is
important. Many parts of the code can update this value and we have no way of
knowing when and how often they might do so. STM allows us to perform atomic
updates. This way any updates to our database will be run sequence even when
coming from different threads. The only cost is that we have to perform any
updates within the context of `IO`.

Our `DB` type will be become `TVar DB`. The `TVar` type represents the
mutable reference. Next, let's create the initial value in the `main`
function:

```haskell
main :: IO ()
main = do
    database <- atomically $ newTVar $ fromList [("__version__", "0.1.0")]
```

This will create a `Map` with a key of `__version__` which has the value
`0.1.0`. Then, it wraps that `Map` in a `TVar` and atomically assigns it
to the `database` variable. Each time we want to write or read the
`database` value, we have to use `IO`. Let's create a helper for atomically
reading this value:

```haskell
atomRead :: TVar a -> IO a
atomRead = atomically . readTVar
```

And let's make a function to update a value in the database. This takes a
function that does the updating and runs it through the STM machinery.

```haskell
updateValue :: (DB -> DB) -> TVar DB -> IO ()
updateValue fn x = atomically $ modifyTVar x fn
```

## Reply parsing {#reply-parsing}

Next, let's talk about the Redis protocol. It's a simple TCP scheme that looks
like this:

```nil
*2\r\n$3\r\nget\r\n$4\r\nname
```

It's a bunch of keywords and arguments separated by newlines. If we clean it up
and break each thing to its own line, we get:

```nil
*2
$3
get
$4
name
```

Let's look at each line. `*2` says to expect a command that has two
arguments. `$3` says that the first argument is three characters long.
`get` is the three-character argument from above. `$4` is the length of the
second argument, and `name` is the value of the second argument. If you're in
the REPL provided by `redis-cli`, and you type `get name`, Redis will
translate those two words into the above representation. A `set` command
would look like this:

```nil
*3
$3
set
$4
name
$5
honza
```

This is what will be sent when you run `set name honza`.

This multi-argument message is called _multibulk_ in the Redis documentation.
There are two other data types that Redis uses that will interest us: the OK and
the error.

When Redis needs to tell you that it accepted request and everything went
smoothly, it simply responds with `+OK`. When Redis needs to indicate an
error, it replies with `-ERR something went wrong` (where "something went
wrong" is the message).

This format is very simple and actually very effective. When we listen on a
socket for incoming messages, we have a look at the very first character. `+`
tells us that it's OK, `-` signals and error, and `*` tells us to keep
reading for commands. We incrementally read from the socket only as much data
as the protocol tells us.

In this section, we will write a parser for multibulk messages. We will use the
amazing attoparsec library for this.

> The following code is heavily influenced by the [Hedis](https://github.com/informatikr/hedis) library. Credit goes
> to Falko Peters. Thanks!

A multibulk message is called a _reply_ in Redis lingo. Let's make a type for it.

```haskell
data Reply = Bulk (Maybe ByteString)
           | MultiBulk (Maybe [Reply])
           deriving (Eq, Show)
```

A `Bulk` reply is a simple string like `get` or `name` above.
`MultiBulk` is the whole message. Let's also write a function that attempts
to convert a `Reply` to a `Command`.

```haskell
parseReply :: Reply -> Maybe Command
parseReply (MultiBulk (Just xs)) =
  case xs of
    [Bulk (Just "get"), Bulk (Just a)]                -> Just $ Get a
    [Bulk (Just "set"), Bulk (Just a), Bulk (Just b)] -> Just $ Set a b
    _                                                 -> Just Unknown
parseReply _ = Nothing
```

Next, let's use attoparsec to write a parser for the `Reply` data type.

```haskell
replyParser :: Parser Reply
replyParser = choice [bulk, multiBulk]
```

Our `replyParser` will try to match either a `bulk` or a `multiBulk`.
Let's implement those:

```haskell
bulk :: Parser Reply
bulk = Bulk <$> do
    len <- char '$' *> signed decimal <* endOfLine
    if len < 0
        then return Nothing
        else Just <$> take len <* endOfLine

multiBulk :: Parser Reply
multiBulk = MultiBulk <$> do
    len <- char '*' *> signed decimal <* endOfLine
    if len < 0
        then return Nothing
        else Just <$> count len replyParser
```

First, the parsers look at the first character to see what kind of message it
is. If it starts with a `$`, it's a bulk. If it starts with a `*`, it's
multibulk. Then, it reads as many characters from the input as the length
indicator said. In the case of multibulk, it recurses because it can contain
bulk messages.

You can now run:

```haskell
> parse replyParser "*2\r\n$3\r\nget\r\n$4\r\nname\r\n"
> (MultiBulk (Just [(Bulk (Just "get")), (Bulk (Just "name"))]))
```

## Networking {#networking}

At this point, we have our data structures ready and we know how to parse
incoming requests into them. Now we need to work on the networking part. Let's
teach our program how to listen on a socket and parse incoming text into
something useful.

Let's change our `main` function to this:

```haskell
main :: IO ()
main = withSocketsDo $ do
    database <- atomically $ newTVar $ fromList [("__version__", version)]
    sock <- listenOn $ PortNumber 7777
    putStrLn "Listening on localhost 7777"
    sockHandler sock database
```

This is pretty straight-forward. Ask for a socket and then listen on it. When
something happens on the socket, run the function `socketHandler`. Let's
implement that next:

```haskell
sockHandler :: Socket -> TVar DB -> IO ()
sockHandler sock db = do
    (handle, _, _) <- accept sock
    hSetBuffering handle NoBuffering
    hSetBinaryMode handle True
    _ <- forkIO $ commandProcessor handle db
    sockHandler sock db
```

Given a socket and a reference to a mutable database, we can get a handle and
start processing requests. For each new connection, run `forkIO` which will
do all this work of parsing and responding on a new lightweight thread. At the
end, we simply recurse to accept new work. The `commandProcessor` function
does the heavy lifting here, so let's write that next.

```haskell
commandProcessor :: Handle -> TVar DB -> IO ()
commandProcessor handle db = do
    reply <- hGetReplies handle replyParser
    let command = parseReply reply
    runCommand handle command db
    commandProcessor handle db
```

This function runs the `replyParser` we wrote earlier. It uses a very clever
function called `hGetReplies` which we will look at in a minute. It will read
as much data as necessary from the handle to get an instance of `Reply`. We
then convert that reply to a command and run it.

```haskell
hGetReplies :: Handle -> Parser a -> IO a
hGetReplies h parser = go S.empty
  where
    go rest = do
        parseResult <- parseWith readMore parser rest
        case parseResult of
            Fail _ _ s   -> error s
            Partial{}    -> error "error: partial"
            Done _ r     -> return r

    readMore = S.hGetSome h (4*1024)
```

The `parseWith` function does partial matching. When it can't parse anything,
it will use the `readMore` function to get more data and try again. The
`readMore` function uses the handle to read more data. Once the parser can
match something, we are done.

## Running commands {#running-commands}

Once we have a command, we can run it!

```haskell
runCommand :: Handle -> Maybe Command -> TVar DB -> IO ()
runCommand handle (Just (Get key)) db = do
    m <- atomRead db
    let value = getValue m key
    S.hPutStr handle $ S.concat ["$", valLength value, crlf, value, crlf]
        where
            valLength :: Value -> ByteString
            valLength = pack . show . S.length
runCommand handle (Just (Set key value)) db = do
    updateValue (insert key value) db
    S.hPutStr handle ok
runCommand handle (Just Unknown) _ =
    S.hPutStr handle $ S.concat ["-ERR ", "unknown command", crlf]
runCommand _ Nothing _ = return ()
```

When the command is a `get`, we read the `DB` atom. Then we construct a
bulk reply and write it to the handle. The bulk reply is in the same format as
our messages above: `$5\r\nhonza\r\n`. The `getValue` function is a lookup
function that returns "null" if a value can't be found.

```haskell
getValue :: DB -> Key -> Value
getValue db k = findWithDefault "null" k db
```

When the command is a `set`, we use our `updateValue` function from above
and write the `ok` to the handle. The `ok` variable is just `+OK\r\n`.

When the command is unknown, we write an error to the handle.

## Compiling and running {#compiling-and-running}

You can now build your program with

```nil
$ stack build
```

And run it with

```nil
$ stack exec Redish
Listening on localhost 7777
```

To test it out, you can connect to it with the `redis-cli` tool:

```nil
$ redis-cli -p 7777
127.0.0.1:7777> set name honza
OK
127.0.0.1:7777> get name
"honza"
```

You can test the performance with something silly, like:

```nil
$ time redis-cli -r 10000 get name
```

## Conclusion {#conclusion}

You can see the finished product on [GitHub](https://github.com/honza/redish). Feedback is welcome, so are
questions.
