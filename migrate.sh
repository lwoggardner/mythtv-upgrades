#!/bin/sh

# Start mysql
/root/mysql/mysql_init.sh || exit 1

# Create mythtv user pwd mythtv and give permisions to mythconverg
/root/mythtv/mythtv_create_db.sh || exit 2

# Restore latest backup
/usr/local/share/mythtv/mythconverg_restore.pl --directory /var/lib/mythtv/backups --verbose --drop-database --create-database || exit 3

# Bootstrap the backend
mythbackend --bootstrap || exit 4

# Backup the database
/usr/local/share/mythtv/mythconverg_backup.pl --directory /var/lib/mythtv/backups --filename mythconverg_upgraded_0.24.sql --verbose || exit 5

# and stop..
/root/mysql/mysql_stop.sh || exit 6
