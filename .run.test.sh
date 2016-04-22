#!/bin/sh
#
CON_NAME=phpdir_phpdef-fpm-goha_1
IMG_VER=5.6.20
IMG_BASE_NAME="trurlmcbyte/phpdir"
IMG_NAME="$IMG_BASE_NAME:$IMG_VER"

#docker build -t $IMG_NAME .

docker stop $CON_NAME
docker rm $CON_NAME
docker run -d  --restart=always  --name $CON_NAME \
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
    -v /usr/share/zabbix:/usr/share/zabbix:ro \
    $IMG_NAME

#    -e WORK_UID=`id -u wwwrun` \
#    -e WORK_GID=`id -g wwwrun` \

#docker export -o $CON_NAME.tar $CON_NAME

sleep 3s

curl -s http://home/test.php | grep -q 'Zend OPcache' \
 && docker tag $IMG_NAME "$IMG_BASE_NAME:5.6" \
 && docker tag $IMG_NAME "$IMG_BASE_NAME:5" \
 && docker tag $IMG_NAME "$IMG_BASE_NAME:latest" \
 && docker push $IMG_BASE_NAME

echo -en "\007"
sleep 1s
echo -en "\007"
