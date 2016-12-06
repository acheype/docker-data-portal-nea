#!/bin/bash

chown www-data:www-data /var/www/html -R
exec /usr/sbin/apachectl -D FOREGROUND
