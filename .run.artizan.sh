#!/bin/sh
#

CON_NAME=phpdir_artizan_1
IMG_NAME=trurlmcbyte/php-fpm:5.6
#BINDIP=`getent hosts $HOST | awk '/10\.9\.8\./ {print $1; exit;}'`

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
docker  run -it --restart=always -d \
    --log-opt max-size=10m \
    --name $CON_NAME \
    -e ENV=production \
    -e TZ=America/Los_Angeles \
    -e WORK_UID=`id -u wwwrun` \
    -e WORK_GID=`id -g wwwrun` \
    -e OPCACHE_ENABLE=yes \
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
    php artisan queue:listen --timeout=60 --sleep=10 --tries=5
#done
