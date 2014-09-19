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

NOTE
----

This also adds 'order: 0' and 'order: last' hooks, which commit at the start
and end of the Salt run. These pick up any changes made *prior* to the salt run
and during the salt run.

As a result, be careful with any other states that run with 'order: 0' or
'order: last' -- specifically if they potentially change any files in /etc.

These are hash-tagged '#salt-start' and '#salt-end' for subsequent use in
monitoring scripts.
