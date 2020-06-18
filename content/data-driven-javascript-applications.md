+++
title = "Data-driven javascript applications"
author = ["Honza Pokorny"]
date = 2011-10-25T11:00:00-03:00
categories = ["code", "javascript"]
draft = false
+++

Over the last few weeks, I have been trying to think of a way to design medium
to large client-heavy web applications. There are many projects and ideas
floating around that are meant to help you with this and I have had a look at
quite a few of them. I don't mean to say that I found the best one --- just one
that I like.

I want to talk about data-driven applications. What I mean is that everything
you do somehow manipulates or shows specific data. Let me describe what I mean
by a way of example. I have been working on a piece of photo gallery software
called `rembrant`. The interface for actually organizing your images into
albums is very client-heavy.

The user interface is similar to that of iPhoto. The larger panel displays a
grid of small thumbnails. The sidebar shows a list of albums and a count of
selected images.

When the application loads, it makes two calls to the server: one to get a list
of all images (image models, including metadata), and a second to get album
information. Everything else in the UI is based on these two lists. The list of
albums and the image grid are pretty self-explanatory.

Once the browser has this data, we can start building out the _views_. A view
is a little windows, or a perspective upon a piece of data. It's meant to
display the data in a meaningful way to the user. For example, in our
application, there is a list of albums in the sidebar. These are represented as
list items with anchor tags:

```javascript
var SidebarView = Backbone.View.extends({
  el: $("#sidebar"),

  events: {
    "click #new-album-link": "newAlbum"
  },

  initialize: function() {
    this.collection.bind("reset", this.render, this);
    this.collection.bind("add", this.add, this);
  },

  add: function(album) {
    var albumView = new SidebarAlbumView({
      model: album
    });
    this.el.append(albumView.el);
  },

  render: function() {
    for (var i = 0; i < this.collection.models.length; i++) {
      this.add(this.collection.models[i]);
    }
  }
});
```

Here you can see we are binding the view to an existing DOM element with an ID
of _sidebar_. The `@collection` variable is the collection of albums we spoke
about earlier. The view subscribes to the collection's _reset_ and _add_
events. When a new album is added to the collection, the view will
automatically update itself. Also, the _events_ hash allows us to bind event
handlers to DOM elements in the sidebar.

You may have noticed that I'm using Backbone to actually structure the
application. I find that Backbone provides a good compromise between structure
and freedom to do as you please. To be honest, it took me a good while to wrap
my head around what Backbone is trying to do for you. It may seem a little
wordy at times but you shouldn't expect your application to consist of little
code.

Now, suppose we wanted to add a count to each album list item which would
indicate how many photos are currently in that album. This is easily done by
inspecting the photos collection. Backbone provides a simple way to filter your
collection based on predefined criteria. To get all photos that belong to the
album with an ID of `1`, we would do:

```javascript
var PhotoCollection = Backbone.Collection.extends({
  model: Photo,
  url: "/photos",

  byAlbum: function(id) {
    this.filter(function(photo) {
      return _.indexOf(photo.get("albums"), id) >= 0;
    });
  }
});

// collection is an instance of PhotoCollection
photos = collection.byAlbum(1);
```

As you can see, this is very simple and elegant. Now, if a photo is deleted, it
will be removed from the collection. This will be reflected both in the grid
and in the sidebar. It will all work automatically because all of the views are
looking at the same date. They are subscribed to the data's events and react
accordingly.

The nice thing is that you don't have to worry about changing classes, binding
data to DOM elements, attaching click handlers, making AJAX requests, none of
this. The difficult part about this approach is deciding what your elementary
data is and how you should get it. In the case of `rembrant` it was pretty
simple.
