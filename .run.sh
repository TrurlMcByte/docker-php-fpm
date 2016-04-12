#!/bin/sh
CON_NAME=phpdir_phpdef-fpm-goha_1
IMG_NAME=trurlmcbyte/phpdir:5.6
BINDIP=`getent hosts $HOST | awk '/10\.9\.8\./ {print $1; exit;}'`


docker run -it --restart=always -d --name $CON_NAME \
    --log-driver=syslog \
    --log-opt syslog-address=udp://10.9.8.50:514 \
    --log-opt syslog-facility=daemon \
    --log-opt tag="$CON_NAME" \
    -p 9002:9000 \
    -h phpdir1.$HOST \
    -e TZ=America/Los_Angeles \
    -e PARENT_HOST=$HOST \
    -e OPCACHE_ENABLE=yes \
    -e WORK_UID=`id -u wwwrun` \
    -e WORK_GID=`id -g wwwrun` \
    -e MOD_MEMCACHE='
extension=memcache.so
memcache.allow_failover = "1"
memcache.max_failover_attempts = "2"
memcache.default_port = "11211"
memcache.chunk_size = "8192"
memcache.dbpath="/var/lib/memcache"
memcache.maxreclevel=0
memcache.maxfiles=0
memcache.archivememlim=0
memcache.maxfilesize=0
memcache.maxratio=0
session.save_handler = memcache
session.save_path = "tcp://10.9.8.8:11211,tcp://10.9.8.7:11211"
' \
    -e FPMOPTS='
pm.status_path = /fpm-docker-status
ping.path = /fpm-docker-ping
request_terminate_timeout = 30s
' \
    -v /etc/timezone:/etc/timezone:ro \
    -v /usr/local/src/site:/usr/local/src/site:ro \
    -v /usr/local/src/app:/usr/local/src/app:ro \
    -v /usr/local/src/themes:/usr/local/src/themes:ro \
    -v /srv/www/htdocs:/srv/www/htdocs:ro \
    -v /srv/nfs/share:/srv/nfs/share \
    -v /home/goha:/home/goha:ro \
    -v /home/pubgoha:/home/pubgoha:ro \
    $IMG_NAME
