#!/bin/bash

VOLUME_HOME="/var/lib/mysql"

if [ ! -d $VOLUME_HOME/mysql ]; then
    echo "=> An empty or uninitialized MySQL volume is detected in $VOLUME_HOME"
    echo "=> Installing MySQL ..."
    mysql_install_db > /dev/null 2>&1
    echo "=> Done!"  
else
    echo "=> Using an existing volume of MySQL"
fi

echo "Starting MYSQL"

mysqld_safe  > /dev/null 2>&1 &

loop=0
# Wait for MySQL to start.
while :
do
    if mysqladmin ping 2>/dev/null ; then
       echo "MYSQL awake after $loop seconds"
       break
    fi
    loop=$(($loop + 1))
    if [ $loop -ge 60 ]; then
        echo "MYSQL not awake after $loop seconds"
        exit 1
    fi
    sleep 1
done


mysql_tzinfo_to_sql /usr/share/zoneinfo | mysql -u root mysql
exit 0
