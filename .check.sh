#!/bin/sh
#scp -C  .run.sh image.tar front03:/srv/nfs/share/vol5/docker/php-goha/
#scp -C  .run.sh front03:/srv/nfs/share/vol5/docker/php-goha/

#for f in 01 02 04 05; do
#for f in 01 04 05 ; do
for f in 05 ; do
#for f in 02 ; do
#    ssh -tA root@front$f docker images
    ssh -tA root@front$f docker ps -a
done
#docker exec -ti phpdir_phpdef-fpm-goha_1 sh -c 'echo "zend_extension=opcache.so" > /usr/local/etc/php/conf.d/docker-php-ext-opcache.ini'
