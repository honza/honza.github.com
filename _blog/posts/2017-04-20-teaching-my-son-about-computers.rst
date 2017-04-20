:title: Teaching my son about computers
:date: 2017-04-20 10:00
:categories:

Teaching my son about computers
===============================

Just over a year ago, my son Wyatt received his first computer for his sixth
birthday.  It's a Raspberry Pi, and he has an old LCD monitor, and a
kid-friendly mouse and keyboard.  I purposely waited until he could read before
starting to teach him about computers.  He's a pretty smart kid, reads a lot (a
Harry Potter book in a weekedn), and is somewhat socially awkward.  Perfect for
a programmer.

The Raspberry Pi doesn't have a cover on it.  The first thing I did was teach
him what each of the parts on the board is.  This is the brain, this is the
memory, this is where power comes in, etc.  His very first task was to plug
everything in.  He had lots of fun trying to figure out where the HDMI cable
goes, where the mouse and keyboard need to be plugged, etc.

Then we turn it on.  He was very excited about LED lights coming to life.

Then we were greeted by a headless login screen.  I made him a proper hacker
handler, ``wjp``, which he was very excited about and allowed him to select a
password.  Then, the computer was ready.

We started out by learning to use bash.  You type in a command and hit "enter"
to run it.  We explored basic unix commands like ``ls``, ``cd``, ``echo``, and
``date``.  Somewhat annoyingly, the hardest concept to explain to a child is
what a file and a directory are.  It tooks us a few tries over many days for the
concept to really sink in.

I taught him to use ``nano`` to write simple text documents.  He had fun writing
down a list of all the superheroes he could think of, a list of countries, a
list of his classmates, and so on.  I installed ``cowsay`` which he loved.

I taught him how to use pipes.  He thought it was hilarious to pipe his
superhero list to ``cowsay``.  We also experimented with ``espeak``.

Then, I installed and configured ``mutt`` for him.  He has his own email address
and can now communicate with his grandparents in Europe on his own.  He still
makes mistakes with the proper email syntax and etiquette but overall does email
well.  More than anything, it's limited by his typing speed.

Wyatt also loves his XMPP client, ``profanity``.  The great thing is that most
people that he wants to chat with have Google phones and can interact with him
without having to install anything.

Annoyingly and most frustratingly, Wyatt has an iPad teacher this year at
school.  They do literally everything on iPads.  Every single story he tells
from school involves an iPad.  He wants us to buy him an iPad.  Many of the
other parents are annoyed about this because it makes children less attentive,
less creative, and much more easily bored.  And I hate it because it messes up
his head about programming.  No, child, ``ls`` is *not* an app, dammit.  Shut
up.  But we make do.

Then one blessed day, I showed him the ``startx`` command to start the X window
system.  He was amazed at the colors and buttons, and everything.  Then, we
started exploring windows, menus, and of course Minecraft.  Yes, kids and their
Minecraft.  He likes to draw in Tuxpain, play chess, tetris, and write books in
Libreoffice.

A couple of weeks ago, I started teaching him basic programming with Python.  He
was very disappointed when he saw the kinds of programs I was going to teach him
to write.  He was under the impression that he was going to write a program that
could turn a movie into a book.  And instead, I suggested we start with "Hello
world!" and leave AI for later.

We started with a simple "Hello world!".  We switched form ``nano`` to `micro`_
which is very similar and has syntax highlighting.  Writing a Hello world
program might seem dumb to experienced programmers but it's great at showing the
novice how to connect everything together: the file, the interpreter, the
command to run the program, etc.

Then, we wrote a simple "Die toss" program.  He was excited about it because it
did something different each time, and not just say the same thing like the
first program.

Yesterday, we wrote a simple quiz.  This time, he wrote all the code by himself
with my telling him how.  Print a question and answers, use ``raw_input()`` to
ask for the user's selection, and then a simple ``if`` statement to determine if
they were correct.  It's amazing how easy Python makes this.

.. code-block:: python

    answer = raw_input()

    if answer is 'b':
        print 'You are correct'


It reads like English.  He very quickly got the concept of if statements, and
started writing more and more questions.  Then, of course, every family member
had to take the quiz.

Later that day, he told his mother that he wanted to be a programmer.  He wants
to write "apps".  His mother suggested that he can ask me to get him a job at
Red Hat, or that he could work at Google.  He scoffed at that and said he didn't
want to work on one project like his Dad, and that, please, there are no
computers or programmers at Google.

.. _micro: https://github.com/zyedidia/micro
