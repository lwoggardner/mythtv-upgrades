# mythtv-upgrades
Docker based database upgrades for Mythtv

It works like this.

We use docker to build a patched version of mythtv 0.24, on a version of ubuntu that was
current when 0.24 was around, so has all the same qt and mysql drivers that the upgrade
code expects.

The patch adds a --bootstrap option to mythbackend, which upgrades the database and then
exits. ie it doesn't need to actually start mythtv, it does just enough to upgrade the
database and that is it.

# Usage:

* Use your existing version of mythtv to create a sql dump backup.
* Create a working directory (eg /var/lib/mythtv/upgrades)
* Copy your backup into the backups folder of your working directory, eg /var/lib/mythtv/upgrades/backups
* Build the Docker image

  docker build -t mythtv-upgrades-0.24 .
  
Note the above, will download ~230Mb of prepacked mythtv, and about 900Mb of Ubuntu 10.04

* Run the upgrade - we mount your working directory in the docker images as /var/lib/mythtv

  docker run -t mythtv-upgrades-0.24 -v/var/lib/mythtv/upgrades:/var/lib/mythtv

* Your upgraded database backup will be written to 'mythconverg_upgraded_0.24.sql'

## Corrupted database

Some versions of mythtv had an issue with charsets - http://www.mythtv.org/wiki/Fixing_Corrupt_Database_Encoding

If the process above produces errors regarding a corrupted database, then try the following...

  docker run -t mythtv-upgrades-0.24 -v/var/lib/mythtv/upgrades:/var/lib/mythtv migrate_corrupted.sh

# TODO

We could really just upload the image to docker hub - all 1.9 Gb of it.
