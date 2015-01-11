#!/bin/sh

# Start mysql
/root/mysql/mysql_init.sh || exit 1

# mimic corrupt server - TODO - there may be more variations here that conflict with certain types of initial backups
mysql -uroot --port "${db_port}" <<SQL
    SET GLOBAL init_connect='SET NAMES latin1';
SQL
# Create mythtv user pwd mythtv and give permisions to mythconverg
/root/mythtv/mythtv_create_db.sh || exit 2

# Restore latest backup
/usr/local/share/mythtv/mythconverg_restore.pl --directory /var/lib/mythtv/backups --verbose --drop-database --create-database || exit 3

# Take a new backup with mythconverg utility
/usr/local/share/mythtv/mythconverg_backup.pl --directory /var/lib/mythtv/backups --verbose --filename mythconverg_corrupt.sql || exit 3
    
# uncompress and do sed replacement of utf8 to latin1 on per table basis
zcat /var/lib/mythtv/backups/mythconverg_corrupt.sql.gz | sed 's/SET NAMES utf8/SET NAMES latin1/' >  /var/lib/mythtv/backups/mythconverg_uncorrupt.sql  || exit 4

# "uncorrupt" the server
mysql -uroot --port "${db_port}" <<SQL 
    SET GLOBAL init_connect='';
SQL

# Restore the uncorrupted backup
/usr/local/share/mythtv/mythconverg_restore.pl --directory /var/lib/mythtv/backups --filename mythconverg_uncorrupt.sql --verbose --drop-database --create-database || exit 5

# Bootstrap the backend
mythbackend --bootstrap || exit 6

# Backup the database
/usr/local/share/mythtv/mythconverg_backup.pl --directory /var/lib/mythtv/backups --filename mythconverg_upgraded_0.24.sql --verbose || exit 7

# and stop..
/root/mysql/mysql_stop.sh || exit 8



