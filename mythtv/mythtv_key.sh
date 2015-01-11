#!/bin/sh

[ -z "$KEY" ] && exit 0

mkdir -p ~/mythtv/.ssh
echo $KEY > ~/mythtv/.ssh/authorized_keys
chown -R mythtv:mythtv ~/mythtv.ssh
chmod 700 ~/mythtv/.ssh
chmod 600 ~/mythtv/.ssh/authorized_keys
