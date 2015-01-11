#!/bin/bash

if [ ! -f "${MYTH_CONFIG}" ]; then

    echo "Creating ${MYTH_CONFIG}"
    #TODO: validate that SQL_PORT is set
    mkdir -p `dirname ${MYTH_CONFIG}`2>/dev/null

    host=`hostname`
    pass=`pwgen -s 8`
    

    cat - > $MYTH_CONFIG << ENDXML 
<Configuration>
  <!-- TODO: This possibly should be the container name" 
  <LocalHostName>my-unique-identifier-goes-here</LocalHostName>
  -->
  <Database>
    <PingHost>1</PingHost>
    <Host>localhost</Host>
    <UserName>mythtv</UserName>
    <Password>$pass</Password>
    <DatabaseName>mythconverg</DatabaseName>
    <Port>$SQL_PORT</Port>
  </Database>
  <WakeOnLAN>
    <Enabled>0</Enabled>
    <SQLReconnectWaitTime>0</SQLReconnectWaitTime>
    <SQLConnectRetry>5</SQLConnectRetry>
    <Command>echo 'WOLsqlServerCommand not set'</Command>
  </WakeOnLAN>
</Configuration>
ENDXML
fi

cat ${MYTH_CONFIG}

# Ensure we have a directory structure in /var/lib/mythtv volume
cp -pr /var/lib/mythtv.dist/* /var/lib/mythtv

# Ensure it has the right permissions
dpkg-reconfigure --frontend=noninteractive mythtv-backend
exit 0

