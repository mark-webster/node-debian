node-debian
===========

Create your own Debian/Ubuntu dpkg install packages (.deb) for any version of node.js

This project doesn't contain the install packages for node. Instead, it provides an
extremely thin set of config files for building your own install packages. This is
useful for sysadmins who manage multiple servers running node.

As you know, the Debian package maintainers take forever to pull newer versions of
node into the official package stream. Also, it can be a pain to create packages
containing custom patches. This project mitigates such inconveniences for the busy
sysadmin!

The resulting packages differ substantially from the official Debian builds. Notably,
it builds a single, statically linked package, instead of separate nodejs, nodejs-dev,
and nodejs-dbg packages. This means you get V8 built in too, which I prefer because
the more "correct" external dependancy, as seen in mainstream Debian, was sometimes a
pain in my ass.


Instructions
============

Run ./build.sh {clean} {version}

eg ./build.sh

or ./build.sh clean

or ./build.sh 0.10.0

or ./build.sh clean 0.8.22


Detailed instructions
=====================

If you are new to building debian packages, you will need to install a lot of Debian
build & packaging tools. I don't know exactly what packages you need to install, but
at a minimum you should have:

 apt-get install devscripts debhelper dpkg-dev make g++ cdbs dh-buildinfo openssl pkg-config build-essential

After this, it should be easy to work out what else you need.

