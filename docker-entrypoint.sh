#!/bin/sh
set -e

write_configs() {
    echo "writing configs.." >&2

    if [ -d /usr/local/etc/php-fpm.d ]; then \
        # for some reason, upstream's php-fpm.conf.default has "include=NONE/etc/php-fpm.d/*.conf"
        sed 's!=NONE/!=!g' /usr/local/etc/php-fpm.conf.default > /usr/local/etc/php-fpm.conf
        cp /usr/local/etc/php-fpm.d/www.conf.default /usr/local/etc/php-fpm.d/www.conf
    else \
        # PHP 5.x don't use "include=" by default, so we'll create our own simple config that mimics PHP 7+ for consistency
        mkdir /usr/local/etc/php-fpm.d
        cp /usr/local/etc/php-fpm.conf.default /usr/local/etc/php-fpm.d/www.conf
        cat > /usr/local/etc/php-fpm.conf << EOF
[global]
include=etc/php-fpm.d/*.conf
EOF
    fi

    cat > /usr/local/etc/php-fpm.d/docker.conf <<EOF
[global]
error_log = ${ERRORLOG_DESTINATION:-/proc/self/fd/2}

[www]
access.log = ${ACCESSLOG_DESTINATION:-/proc/self/fd/2}

clear_env = no

; Ensure worker stdout and stderr are sent to the main error log.
catch_workers_output = yes
EOF

    cat > /usr/local/etc/php-fpm.d/zz-docker.conf <<EOF
[global]
daemonize = no

[www]
listen = [::]:9000
EOF

touch /usr/local/etc/php.configured
}

test -e /usr/local/etc/php.configured || write_configs
test "${OPCACHE_ENABLE}" && echo "zend_extension=opcache.so" > /usr/local/etc/php/conf.d/docker-php-ext-opcache.ini
test "${OPCACHE_DISABLE}" && rm /usr/local/etc/php/conf.d/docker-php-ext-opcache.ini

if [ $# -eq 0 ]; then
    /usr/local/sbin/php-fpm
fi

exec "$@"
