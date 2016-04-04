docker run -it --restart=always -d --name phpdir_phpdef-fpm-goha_1 \
    -p 9002:9000 \
    -e TZ=America/Los_Angeles \
    -e PARENT_HOST=$HOST \
    -v /etc/timezone:/etc/timezone:ro \
    -v /usr/local/src/app:/usr/local/src/app:ro \
    -v /usr/local/src/themes:/usr/local/src/themes:ro \
    -v /srv/www/htdocs:/srv/www/htdocs:ro \
    -v /srv/nfs/share:/srv/nfs/share \
    -v /home/goha:/home/goha:ro \
    -v /home/pubgoha:/home/pubgoha:ro \
    phpdir_phpdef-fpm-goha
