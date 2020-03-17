+++
title = "How I back up my laptop"
author = ["Honza Pokorny"]
date = 2013-07-15T15:20:00-03:00
categories = ["backup"]
draft = false
+++

For the longest time, I was using Time Machine to keep copies of my files.  I
don't remember ever wishing I could go back in time and retrieve an older
version of a file.  What does keep me up at night though is forever losing all
of the pictures of our kids because my hard drive failed.

I also don't particularly like tools like Time Machine,  Carbon Copy Cloner or
SuperDuper.  They are some kind of GUI app that does stuff, and I like my unix
tools.

Here are my requirements for a good backup solution:


## Incremental - that means don't overwrite older backups and don't back up {#incremental-that-means-don-t-overwrite-older-backups-and-don-t-back-up}

everything every time


## Efficient storage - I shouldn't need 10 TB to keep a few backups of my hard {#efficient-storage-i-shouldn-t-need-10-tb-to-keep-a-few-backups-of-my-hard}

drive


## Bootable - if my hard drive fails or laptop gets stolen, I want to be able {#bootable-if-my-hard-drive-fails-or-laptop-gets-stolen-i-want-to-be-able}

to back to work quickly

When you do some research into this, you will see mostly suggesting rsync.  It
can copy your entire drive and does smart, incremental backups.  Except it
overwrites stuff and you only get to keep the latest copy.

Enter [bup](https://github.com/bup/bup).  Bup is simply amazing.  It's based on git and it gives you
automatic incremental, deduplicated, shared backups.  Free and open source.

Backing up huge virtual machines?  It only backs up what changed, not the whole
file.  Multiple copies of the same stuff on your hard drive?  Only needs to
store one copy.  Have a look at their documentation for more information about
how it works and what the benefits are.

The way you use bup is by creating a tar archive stream of all your data and
sending it to bup on stdin.  Bup takes it, chunks, deduplicates it and stores
in a git repo.

The canonical example goes like this:

```nil
tar -cvf - /etc | bup split -n local-etc
```

The `-n` flag just allows you to name your backup.

Next, we have to figure out how to tar up our entire drive.  This can be a
little tricky because there are some special files which we don't want to copy
over.  After much trial, error and googling, I came up with the following list
of exclusions.  Note that this only applies to OS X.

```nil
.Spotlight-*/
.Trashes
/afs/*
/automount/*
/cores/*
/dev/*
/Network/*
/private/tmp/*
/private/var/run/*
/private/var/spool/postfix/*
/private/var/vm/*
/Previous Systems.localized
/tmp/*
/Volumes/*
*/.Trash
```

Save this to `excludes.txt` and then use this tar command:

```nil
$ tar -cvf - / -X excludes.txt | bup split -n backup
```

This takes about 1-2h on my system (128GB SSD, 500GB 5400rpm external).
Subsequent backups take a lot less time.  As far as actual backup goes, we're
done.

How do you restore?

The nice thing about bup is that it stores your backups in a git repository.
This means that you can go back in history and decide from which point in time
you'd like to restore.  Bup allows you to spit out a tar file like this:

```nil
$ bup join backup -o backup.tar
```

This will again take some time and use quite a bit of resources (git will eat
your RAM and CPU - a 6GB git process anyone?).  Once that is done, you can
extract the tar to a drive that can be booted into.  This can be the internal
drive on a new computer or a GUID-partitioned external drive.

Once extracted, you just have to _bless_ the data to make it bootable:

```nil
$ sudo bless -folder /System/Library/CoreServices
```

Then, you should reboot your Mac while holding down the Option key.  This will
show you the boot order menu and allow you to specify where you'd like to boot
from.

Of course, you should wrap all of this in a script and run it periodically.
