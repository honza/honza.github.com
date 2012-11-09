:title: Upgrading your Django media files to use a CDN
:date: 2012-01-17 08:45
:categories: Code, Django, Python

Upgrading your Django media files to use a CDN
==============================================

I was using `django-filebrowser`_ on a project and my Rackspace VM quickly ran
out of disk space. Since the site isn't getting much traffic at all, I didn't
want to pay extra for a bigger VM. Instead, I decided to move all of the user
uploaded media to `Rackspace Cloudfiles`_. It's super cheap and they have a
nice API.

Now, the challenge was to make the transition from a filebrowser-based system.
First of all, I knew I was going to use `django-storages`_ as the new storage
class for my class. I played around with it on the side and it worked like a
charm.

Next, I wrote a quick little Python script to upload all of the files to
Cloudfiles. Since the filenames didn't change at all, I could just write a
South migration that would strip the ``/uploads`` part and be done with it.

I had a look at the Django documentation to see what exactly a `FileField`_ was.
It turns out it takes a Django `File`_ object which in turn is a thin wrapper
around the Python built-in file object. This didn't sound exactly easy to do. I
would have to open a remote file with Python's ``open('file.mp3')`` and have
Django inspect it for size and file type. This is clunky at best if you
remember that this will have to live in a South migration.

Also worth noting is the fact that filebrowser's model field is a subclass of
``CharField`` and has no special file-related properties or methods.

You can't use the ``DEFAULT_STORAGE_CLASS`` setting because filebrowser will
start yelling at you. Instead, you specify the storage class right in the new
model field.

.. code-block:: python

    from storages.backends.mosso import cloudfiles_upload_to, CloudFilesStorage
    cloudfiles_storage = CloudFilesStorage()

    class Item(models.Model):
        old_field = FileBrowseField(max_length=500, blank=True)
        new_field = models.FileField(upload_to=cloudfiles_upload_to,
                storage=cloudfiles_storage, default='')

Now you can go and write your migration and Django won't yell at you. Now we go
back to the problem outlined above. How do you create an instance of ``File``
to pass to ``item.new_field``.

After hours of reading the source and debugging, I realized that you can simply
pass in the filename as a string and the storage class will do the right thing.
It's actually really simple and painless. Your data migration might look
something like:

.. code-block:: python

    for item in orm.Item.objects.all():
        item.new_field = os.path.basename(item.old_field.url)
        item.save()

So, I was already somewhat overjoyed that this would in fact be easy and then I
discovered that the change from filebrowser to django-storages doesn't require
a schema migration. This means that if your file names are the same there is no
database change needed at all. How cool is that?


.. _django-filebrowser: http://readthedocs.org/docs/django-filebrowser/en/latest/
.. _Rackspace Cloudfiles: http://www.rackspace.com/cloud/cloud_hosting_products/files/
.. _django-storages: http://django-storages.readthedocs.org/en/latest/index.html
.. _FileField: https://docs.djangoproject.com/en/1.3/ref/models/fields/#filefield
.. _File: https://docs.djangoproject.com/en/1.3/ref/files/file/#django.core.files.File
