=======
etckeeper
=======

Formula to set up and configure 'etckeeper' on a server.

Etckeeper is a simple wrapper around a version control system - Git in this
case - to keep an historical record of /etc changes.

There is no daemon process, it essentially hooks into package installation and
cron to periodically commit the state of the /etc directory.

Note that this will store the Git DB at /etc/.git, and as such will increase
the size of your root filesystem over time.

Dependencies
============

.. note::

   This formula has a dependency on the following salt formulas:

   `bootstrap <https://github.com/ministryofjustice/bootstrap-formula>`_ -- for
   git

