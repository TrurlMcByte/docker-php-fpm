#!/bin/sh
#
CON_NAME=php-fpm-main
BUILD_MARK='PHP_VERSION'
IMG_VER=`grep "${BUILD_MARK}=" Dockerfile | cut -d '=' -f 2 | cut -d ' ' -f 1`
IMG_BASE_NAME="trurlmcbyte/php-fpm"
IMG_NAME="$IMG_BASE_NAME:$IMG_VER"
SUBTAGS="7.2 7"

IP=`ifconfig | awk '/^(eth|eno)[0-9]+[ \t]/ {getline; split($2,a,":"); if(a[2]!~/72\.51/) { print a[2]; exit; } }'`

. ./.geoup.sh

if test "${IMG_BASE_NAME%/*}" = "trurlmcbyte"; then
    set -eo pipefail
    test -f ./build.log && mv -fb ./build.log ./build.log.old
    docker build --pull -t $IMG_NAME . | tee ./build.log
else
    docker pull $IMG_NAME
fi

  docker stop -t 2 $CON_NAME || true
  docker rm $CON_NAME || true

#    -p 9002:9000 \
#    -l port.9000=php-fpm \
#    --net=docker-home-net \
#    --net-alias=php-fpm \
#    --log-driver=syslog \
#    --log-opt syslog-address=udp://192.168.1.11:514 \
#    --log-opt syslog-facility=daemon \
#    --log-opt tag="$CON_NAME" \
#    -e MOD_XDEBUG='
#xdebug.remote_enable = 1
#xdebug.remote_autostart = 1
#xdebug.remote_port=9009
#xdebug.remote_handler=dbgp
#xdebug.remote_host=192.168.1.15
#xdebug.max_nesting_level=1000
#xdebug.auto_trace=1
#xdebug.show_mem_delta=1
#' \

docker run -d  --restart=always  --name $CON_NAME \
    --log-opt max-size=10m \
    --cap-add SYS_PTRACE \
    -p 9002:9000 \
    -l port.9000=php-fpm \
    -p 9009:9009 \
    -l port.9009=php-xdebug \
    -e TZ=America/Los_Angeles \
    -e ENV=home \
    -e WORK_UID=`id -u wwwrun` \
    -e WORK_GID=`id -g wwwrun` \
    -e OPCACHE_ENABLE='yes' \
    -e MOD_MEMCACHE='yes' \
    -e MOD_XDEBUG='
xdebug.remote_enable = 1
xdebug.remote_autostart = 1
xdebug.remote_port=9009
xdebug.remote_handler=dbgp
xdebug.remote_host=192.168.1.15
xdebug.max_nesting_level=1000
xdebug.auto_trace=1
xdebug.show_mem_delta=1
' \
    -e FPMGOPTS='' \
    -e FPMOPTS='' \
    -v /etc/timezone:/etc/timezone:ro \
    -v /etc/ssl/phpki-store:/etc/ssl/phpki-store \
    -v /usr/local/src/site:/usr/local/src/site:ro \
    -v /usr/local/src/app:/usr/local/src/app:ro \
    -v /usr/local/src/app:/usr/local/src/trumedia:ro \
    -v /usr/local/src/themes:/usr/local/src/themes:ro \
    -v /srv/www/htdocs:/srv/www/htdocs:ro \
    -v /srv/nfs/share:/srv/nfs/share \
    -v /home/goha:/home/goha:ro \
    -v /home/pubgoha:/home/pubgoha:ro \
    -v /usr/share/zabbix:/usr/share/zabbix:ro \
    $IMG_NAME




#    -e OPCACHE_ENABLE=yes \
#    -e WORK_UID=`id -u wwwrun` \
#    -e WORK_GID=`id -g wwwrun` \

#docker export -o $CON_NAME.tar $CON_NAME

sleep 3s

echo -en "\007"
echo -en "\007" > /dev/console

echo "Done image $IMG_NAME"

read
set +e
set +o pipefail

if curl -s http://home/test.php | grep -q "PHP Version $IMG_VER"; then
  echo "Build $IMG_NAME is OK"
  test "${IMG_BASE_NAME%/*}" = "trurlmcbyte" && \
  docker push "$IMG_NAME"
  for TAG in $SUBTAGS; do
    docker tag $IMG_NAME "$IMG_BASE_NAME:$TAG"
    docker push "$IMG_BASE_NAME:$TAG"
  done
fi


