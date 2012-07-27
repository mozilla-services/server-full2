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

The Sync Server software runs using **python 2.6**, and the build process
requires **make**, **virtualenv**, **git**, **libmemcached** and **zeromq**.
You will need to have the following packages (or similar, depending on your
operating system) installed:

- python2.7
- python2.7-dev
- python-virtualenv
- make
- git
- libmemcached
- libmemcached-dev
- libzmq
- libzmq-dev

Take a checkout of this repository, then run "make build" to pull in the 
necessary python package dependencies::

    $ git clone https://github.com/mozilla-services/server-full2
    $ cd server-full2
    $ make build

To sanity-check that things got installed correctly, do the following::

    $ make test

Now you can run the server::

    $ make serve

This should start a server on http://localhost:5000/.  There is no
Sync2.0 client built into firefox yet, but you can test it out by running
the functional testsuite against your server::

    $ ./bin/python ./deps/server-syncstorage/syncstorage/tests/functional/test_storage.py --use-token-server --audience=http://localhost:5000 http://localhost:5000/1.0/sync/2.0

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
