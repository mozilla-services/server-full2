#!/bin/sh
#
# Build a MySQL-based storage node for picl-server.

set -e

YUM="yum --assumeyes"

$YUM update
$YUM install mysql mysql-server

# Add ssh public keys.

git clone https://github.com/mozilla/identity-pubkeys
cd identity-pubkeys
git checkout b63a19a153f631c949e7f6506ad4bf1f258dda69
cat *.pub >> /home/ec2-user/.ssh/authorized_keys
cd ..
rm -rf identity-pubkeys

# Set up MySQL

/sbin/chkconfig mysqld on
/sbin/service mysqld start

echo "CREATE USER 'sync' IDENTIFIED BY 'syncerific';" | mysql -u root
echo "CREATE DATABASE sync;" | mysql -u root
echo "GRANT ALL ON sync.* TO 'sync';" | mysql -u root

