+++
title = "Password Management For a More Civilized Age"
author = ["Honza Pokorny"]
date = 2019-12-04T10:14:00-04:00
categories = ["passwords"]
draft = false
+++

It is a universally acknowledged truth that remembering your passwords is a bad
idea.  The modern Internet user will inevitably be required to register for
many services, and websites, and inventing a new password for each one will
quickly overwhelm him or her.  The burden of memorizing one's passwords is too
great to bear.  Unless, of course, we grant that passwords may be reused---that
we shall never do.  Once we are satisfied that keeping all of one's passwords
in one's head is a bad idea, we shall proceed to delegating this task to
computers.  If your computer is managing your passwords, you are free to use a
different one for every entity, and you are enabled and encouraged to create
very long and random passwords.

Many solutions exist to address this need.  LastPass and 1Password come to
mind.  However, most of these services store your data in the cloud, aren't
open source, and cost money.

Can we do better?

Here are our requirements:

-   Encrypted storage of passwords (which enables easy backups)
-   A browser extension to fill in login credentials
-   A way for mobile devices to access passwords
-   Tracking of password changes
-   Each password generation
-   Free and open-source software
-   Managing the password store via Unix tools


## Step 1: GPG {#step-1-gpg}

We are going to use GPG to encrypt our passwords at rest.  This has the
advantage of not having to remember encryption passphrases.  If you encrypt
your passwords to your own key, only you can ever decrypt it.

For a modern GPG workflow, I recommend using a YubiKey to store your private
keys.  YubiKeys can be used as a SmartCard, meaning that your private GPG key
can be stored on the key.  Moving your private key to the YubiKey is a
destructive process which means that the key cannot be extracted from it.  It
also means that all operations which require your private key are performed on
the SmartCard.

There is an excellent [guide](https://github.com/drduh/YubiKey-Guide) on how to set it up.  It walks you through
generating your GPG keys on an air-gapped computer running a live version of
[Tails](https://tails.boum.org/) Linux.  You create a master private key which is stored offline in a
secure place, and multiple subkeys which are used for day-to-day operations.

Paul Stamatiou has a great [article](https://paulstamatiou.com/getting-started-with-security-keys/) on getting started with security keys in
general.

All of this means that your computer can only use your private key if your
YubiKey is plugged in.


## Step 2: pass {#step-2-pass}

The next piece of the puzzle is the password store itself.  For this, we will
use [pass](https://www.passwordstore.org/).  This is a Unix command-line program which stores your passwords
in a directory on your filesystem as GPG-encrypted plain text files.  By
default, everything lives in `$HOME/.password-store`, and you can organize
your passwords into directories.  The `pass` program then handles encrypting
and decrypting on the fly.

It also has a nice feature which makes it easy to move your passwords to your
phone.  Most of the time, you only need the password to set up an app, and
after that the app maintains a session.  Pass can show you a QR code
representation of your password which you can scan with your smartphone's
camera to place it in the phone's clipboard.

Optionally, `pass` can initialize a git repository inside its password store
directory, and create a git commit for each password modification or
manipulation operation.

Pass is also free and open source (GPL).


## Step 3: passff {#step-3-passff}

Copying passwords from the terminal and pasting them into login forms in the
browser isn't very smooth.  There is a project called [passff](https://github.com/passff/passff) which
integrates `pass` into Firefox.  This consists of a browser extension, and a
simple Firefox web service which handles communication with your password
store.  When you need to log in, Firefox can look up the correct password for
that entity, and fill in the form for you.


## Step 4: backups {#step-4-backups}

It's trivial to back up your passwords.  Currently, I use `tar` to create a
bundle of my password store, and encrypt it and sign it with my private GPG
key.  This encrypted file can then be safely placed in your favorite regular
pipeline.
