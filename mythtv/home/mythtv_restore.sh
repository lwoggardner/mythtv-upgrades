#!/bin/bash

# Step 1 - find latest backup in /var/lib/mythtv/backups

echo "DBBackupDirectory=/var/lib/backups" > ~/.mythtv/backuprc

# TODO - don't attempt restore if there are no backups
mythconverg_restore.pl --drop_database --create_database

mythbackend --bootstrap < /dev/null

# Step 2 - run mythtv-setup - hmmm, I'm headless - but that's ok because setup will upgrade the database before aborting due to lack of X - would be nice if backend or setup could be run to just do the schema upgrade - Feature request?


# Step 3 if CONFIG backup available in /var/lib/mythtv/backups/CONFIG_backup.sql
# 3a - take a new backup (into /tmp)
# 3b - restore CONFIG backup with mythconverg_restore.pl
# 3c - partial restore data mythconverg_restore.pl --with_plugin_data from backup in /tmp

