#!/bin/bash

# http://www.tothenew.com/blog/setting-up-sendmail-inside-your-docker-container/
line=$(head -n 1 /etc/hosts)
line2=$(echo $line | awk '{print $2}')
echo "$line $line2.localdomain" >> /etc/hosts
service sendmail start

/opt/archivesspace/scripts/setup-database.sh
exec /opt/archivesspace/archivesspace.sh
