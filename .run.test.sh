#!/bin/sh
#
CON_NAME=phpdir_phpdef-fpm-goha_1
IMG_NAME=trurlmcbyte/phpdir:5.6.20

docker build -t $IMG_NAME .

docker stop $CON_NAME
docker rm $CON_NAME
docker run -d --name $CON_NAME \
    --log-driver=syslog \
    --log-opt syslog-address=udp://192.168.1.11:514 \
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
' \
    -e FPMGOPTS='' \
    -e FPMOPTS='' \
    -v /etc/timezone:/etc/timezone:ro \
    -v /usr/local/src/site:/usr/local/src/site:ro \
    -v /usr/local/src/app:/usr/local/src/app:ro \
    -v /usr/local/src/themes:/usr/local/src/themes:ro \
    -v /srv/www/htdocs:/srv/www/htdocs:ro \
    -v /srv/nfs/share:/srv/nfs/share \
    -v /home/goha:/home/goha:ro \
    -v /home/pubgoha:/home/pubgoha:ro \
    $IMG_NAME

#    -e WORK_UID=`id -u wwwrun` \
#    -e WORK_GID=`id -g wwwrun` \

#docker export -o $CON_NAME.tar $CON_NAME

sleep 1s

curl -s http://home/test.php | grep -q 'Zend OPcache' \
 && docker tag $IMG_NAME trurlmcbyte/phpdir:5.6 \
 && docker tag $IMG_NAME trurlmcbyte/phpdir:5 \
 && docker tag $IMG_NAME trurlmcbyte/phpdir:latest \
 && docker push trurlmcbyte/phpdir

