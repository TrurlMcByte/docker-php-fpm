#!/bin/sh
CON_NAME=phpdir_phpdef-fpm-goha_1
IMG_NAME=trurlmcbyte/phpdir:5.6

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
    -v /etc/timezone:/etc/timezone:ro \
    -v /usr/local/src/site:/usr/local/src/site:ro \
    -v /usr/local/src/app:/usr/local/src/app:ro \
    -v /usr/local/src/themes:/usr/local/src/themes:ro \
    -v /srv/www/htdocs:/srv/www/htdocs:ro \
    -v /srv/nfs/share:/srv/nfs/share \
    -v /home/goha:/home/goha:ro \
    -v /home/pubgoha:/home/pubgoha:ro \
    $IMG_NAME
