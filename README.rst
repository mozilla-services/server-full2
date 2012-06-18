Experimental Run-Your-Own Sync2.0 Server
========================================

This is an experimental codebase for running a standalone Sync2.0 server.
It may be useful for third-party developers who want to preview and prepare
for the upcoming Sync2.0 protocol and related API changes (see 
http://docs.services.mozilla.com/storage/apis-2.0.html for the details).

This repo is likely to be retired and replaced with something else as
development progresses.  It really is only for early adopters to try things
out and give us feedback.  You have been warned...


Getting Started
---------------

Take a checkout of this repository, then run "make build" to pull in the 
necessary dependencies::

    $ git clone https://github.com/mozilla-services/server-full2
    $ cd server-full2
    $ make build

To sanity-check that things got installed correctly, do the following::

    $ make test

This may report that M2Crypto did not build correctly.  If so, try symlinking
in the copy from your system python like so::

    $ # Remove the broken local install of M2Crypto
    $ rm -rf ./lib/*/site-packages/M2Crypto*
    $ # Install m2crypto using your system package manager.
    $ sudo apt-get install python-m2crypto
    ...
    $ # Find the directory containing M2Crypto on your system.
    $ python -c 'import M2Crypto; print M2Crypto.__file__'
    /usr/lib/python2.7/dist-packages/M2Crypto/__init__.pyc
    $ # Symlink all M2Crypto files into into your virtualenv
    $ ln -s /usr/lib/python2.7/dist-packages/M2Crypto* ./lib/*/site-packages/
    $ # Now the tests should pass.
    $ make test

Now you can run the server via paster::

    $ ./bin/paster serve ./etc/production.ini

This should start a server on http://localhost:5000/.  There is no
Sync2.0 client build into firefox yet, but you can test it out by running
the functional testsuite against your server::

    $ ./bin/python ./deps/https:/github.com/mozilla-services/server-syncstorage/syncstorage/tests/functional/test_storage.py --use-token-server --audience="http://localhost:5000" http://localhost:5000/1.0/sync/2.0

If that reports no errors, congratulations!  You have a basic working install
of the Sync2.0 server.


Customization
-------------

All customization of the server can be done by editing the file
"./etc/production.ini", which contains lots of comments to help you on
your way.  Things you might like to change include:

    * The client-visible hostname for your server.  Edit the "service_entry"
      key under the [tokenserver] section, the "audiences" key under the
      [browserid] section, and the corresponding entry in the file
      "./etc/secrets".

    * The database in which to store sync data.  Edit the various settings
      under the [storage] section.


Questions, Feedback
-------------------

- IRC channel: #sync. See http://irc.mozilla.org/
- Mailing list: https://mail.mozilla.org/admin/services-dev
