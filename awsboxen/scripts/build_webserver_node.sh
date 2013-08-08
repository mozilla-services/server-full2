#!/bin/sh
#
# Build a server-storage webhead node for AWS deployment.

set -e

YUM="yum --assumeyes --enablerepo=epel"

$YUM update
$YUM install python-pip mercurial git

# Checkout and build latest server-storage.

python-pip install virtualenv

useradd syncstorage

UDO="sudo -u syncstorage"

cd /home/syncstorage
$UDO git clone https://github.com/mozilla-services/server-full2.git
cd ./server-full2
git checkout -t  origin/awsboxen-deployment

$YUM install openssl-devel libmemcached-devel libevent-devel python-devel
$YUM install gcc gcc-c++ czmq-devel zeromq

$UDO make build
$UDO ./bin/pip install gunicorn PyMySQL pymysql_sa
$UDO ./bin/pip install "cornice==0.11"

# Write the configuration files.

cat >> ./etc/production.ini << EOF

# Extra configuration from awsboxen deployment.

[tokenserver]
service_entry =  http://web.sync2.profileinthecloud.net

[browserid]
audiences =  http://web.sync2.profileinthecloud.net

[storage]
sqluri = pymysql://sync:syncerific@db.sync2.profileinthecloud.net/sync

EOF


cat >> ./etc/secrets << EOF
http://web.sync2.profileinthecloud.net,12345:MYSUPERSECRET
EOF

# Write a circus config script.

cd ../
cat > sync.ini << EOF
[watcher:syncstorage]
working_dir=/home/syncstorage/server-full2
cmd=bin/gunicorn_paster -w 4 ./etc/production.ini
numprocesses = 1
EOF
chown syncstorage:syncstorage sync.ini

# Launch the server via circus on startup.

python-pip install circus

cat > /etc/rc.local << EOF
su -l syncstorage -c '/usr/bin/circusd --daemon /home/syncstorage/sync.ini'
exit 0
EOF


# Setup nginx as proxy.

$YUM install nginx

/sbin/chkconfig nginx on
/sbin/service nginx start

cat << EOF > /etc/nginx/nginx.conf
user  nginx;
worker_processes  1;
events {
    worker_connections  20480;
}
http {
    include       mime.types;
    default_type  application/octet-stream;
    log_format xff '\$remote_addr - \$remote_user [\$time_local] "\$request" '
                   '\$status \$body_bytes_sent "\$http_referer" '
                   '"\$http_user_agent" XFF="\$http_x_forwarded_for" '
                   'TIME=\$request_time ';
    access_log /var/log/nginx/access.log xff;
    server {
        listen       80 default;
        location / {
            proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
            proxy_set_header Host \$http_host;
            proxy_redirect off;
            proxy_pass http://localhost:5000;
        }
    }
}
EOF
