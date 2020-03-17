+++
title = "Writing Node.js modules"
author = ["Honza Pokorny"]
date = 2012-01-05T14:00:00-04:00
categories = ["code", "javascript"]
draft = false
+++

To say that node.js has enjoyed a great deal of positive publicity in the last
few months would most certainly be an understatement. New node.js-related
projects are popping up all over the place, and there seems to be this notion
that if you aren't using it you're not cool enough.

Over the Christmas holidays, I sat down to sort out my photo library and I
wanted to make a web photo gallery to share the images with family and friends.
Being a mainly Python programmer, I wrote a Python script that will go through
all of my photos and create smaller versions and thumbnails of the images that
are suitable for the web. I think I have around 1500 images at the moment and
it took a good 20 minutes to convert everything using Python Imaging Library.

I was rather frustrated with the performance. I think the reason for the
slowness was the fact that the images were processed sequentially, one by one.
What if I could modify my program to process more than one image at a time.
This would certainly speed by the process. Then I thought about using threads
in Python and I think I threw up in my mouth a little.

Then I remembered Node.js. It's supposed to be all asynchronous and
non-blocking. Perfect match. So I wrote a thumbnailer in node.

Essentially, it's a worker queue that resizes images. You give it a source and
destination directories and a number of workers and run it. The total time went
from 20 minutes to 2 using about 5 workers. Much better, eh?

I decided to open source the project because I couldn't find any node.js
projects that do something even remotely similar. It's called [node-thumbnail](https://github.com/honza/node-thumbnail)
and you can find it on both Github and npmjs.

So what does the API look like?

```javascript
thumb({
  source: 'source/path',
  destination: 'dest/path',
  concurrency: 4
  }, function() {
  console.log('All done!');
});
```
