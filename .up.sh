#!/bin/sh
scp -C  .run.sh front03:/srv/nfs/share/vol5/docker/php-goha/
#scp -C  deploy front03:/srv/nfs/share/vol5/docker/php-goha/

for f in 01 02 04 05; do
#for f in 05 ; do
#for f in 01 02 04 ; do
#    ssh -tA root@front$f ls -l /srv/nfs/share/vol5/docker/php-goha/
#    ssh -tA root@front$f docker images
#    ssh -tA root@front$f docker ps -a
#    ssh -tA root@front$f rcdocker restart
#    sleep 10s
    ssh -tA root@front$f docker pull trurlmcbyte/php-fpm:5.6
    ssh -tA root@front$f sh /srv/nfs/share/vol5/docker/php-goha/.run.sh
#    ssh -tA root@front$f docker exec -ti phpdir_phpdef-fpm-goha_1 cp /srv/nfs/share/vol5/docker/php-goha/memcache.ini /usr/local/etc/php/conf.d/docker-php-ext-memcache.ini
##    ssh -tA root@front$f docker exec -ti phpdir_phpdef-fpm-goha_1 cp /srv/nfs/share/vol5/docker/php-goha/opcache.ini /usr/local/etc/php/conf.d/docker-php-ext-opcache.ini
#    ssh -tA root@front$f docker restart phpdir_phpdef-fpm-goha_1
#    ssh -tA root@front$f docker images
    ssh -tA root@front$f docker ps
done
#docker exec -ti phpdir_phpdef-fpm-goha_1 sh -c 'echo "zend_extension=opcache.so" > /usr/local/etc/php/conf.d/docker-php-ext-opcache.ini'
