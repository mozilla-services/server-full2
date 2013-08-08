#!/bin/sh
#
# Build a MySQL-based storage node for picl-server.

set -e

YUM="yum --assumeyes"

$YUM update
$YUM install mysql mysql-server

/sbin/chkconfig mysqld on
/sbin/service mysqld start

echo "CREATE USER 'sync' IDENTIFIED BY 'syncerific';" | mysql -u root
echo "CREATE DATABASE sync;" | mysql -u root
echo "GRANT ALL ON sync.* TO 'sync';" | mysql -u root

