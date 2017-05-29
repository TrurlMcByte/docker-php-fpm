#!/bin/sh
#scp -C  .run.sh image.tar front03:/srv/nfs/share/vol5/docker/php-goha/
scp -C  .run.sh .run.artizan.sh front03:/srv/nfs/share/vol5/docker/php-goha/
exit

for f in 01 02 04 05; do
#for f in 01 04 05 ; do
#for f in 05 ; do
#for f in 02 ; do
    echo "front$f"
#    ssh -tA root@front$f docker images
    ssh -tA root@front$f docker ps -a
#    ssh -tA root@front$f docker exec -ti phpdir_1 php -v
#    ssh -tA root@front$f docker exec -ti phpdir_1 ls -l /srv/nfs/share/vol5/deploy/projects/staging/main/bootstrap/../app/Application.php
#    ssh -tA root@front$f "rm -rf /tmp/systemd-private-*-php-fpm.service-*/tmp/*"

done
#docker exec -ti phpdir_phpdef-fpm-goha_1 sh -c 'echo "zend_extension=opcache.so" > /usr/local/etc/php/conf.d/docker-php-ext-opcache.ini'
