#!/bin/sh

#for i in 1 2 3 4; do


CON_NAME=phpdir_artizan_1
IMG_NAME=trurlmcbyte/php-fpm:5.6
BINDIP=`getent hosts $HOST | awk '/10\.9\.8\./ {print $1; exit;}'`

docker stop -t 4 $CON_NAME
docker kill $CON_NAME
docker rm -f $CON_NAME

#    --log-driver=syslog \
#    --log-opt syslog-address=udp://10.9.8.50:514 \
#    --log-opt syslog-facility=daemon \
#    --log-opt tag="$CON_NAME" \

# --restart=always -d \
#    -l port.9000=php-fpm \
#    -p 9002:9000 \
docker  run -it \
    --log-opt max-size=10m \
    --name $CON_NAME \
    -e ENV=production \
    -e TZ=America/Los_Angeles \
    -e WORK_UID=`id -u wwwrun` \
    -e WORK_GID=`id -g wwwrun` \
    -e MOD_MEMCACHE='
;extension=memcache.so
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
    -e MOD_XCACHE='
[xcache.admin]
xcache.admin.enable_auth = On
xcache.admin.user = "mOo"
xcache.admin.pass = "a02ae907dce951156a1a5bd67ecdac78"
[xcache]
xcache.shm_scheme =        "mmap"
xcache.size  =               256M
xcache.count =                 2
xcache.slots =                4K
xcache.ttl   =                 88400
xcache.gc_interval =           910
xcache.var_size  =            8M
xcache.var_count =             1
xcache.var_ttl   =             604800
xcache.var_gc_interval =     300
xcache.test =                Off
xcache.readonly_protection = Off
xcache.mmap_path =    "/tmp/xcache"
xcache.cacher =               On
xcache.stat   =               On
xcache.optimizer =            On
[xcache.coverager]
xcache.coverager =          Off
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
    --workdir=/srv/nfs/share/vol5/deploy/projects/staging/main \
    $IMG_NAME \
    php artisan queue:listen --timeout=60 --sleep=10 --tries=5 --daemon
#done
