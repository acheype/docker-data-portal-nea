# Based on Julien Jancelin's image (https://github.com/jancelin/docker-lizmap)

FROM ubuntu:16.04
MAINTAINER adrien.cheype@ird.fr

RUN  export DEBIAN_FRONTEND=noninteractive
ENV  DEBIAN_FRONTEND noninteractive
RUN  dpkg-divert --local --rename --add /sbin/initctl

# Add qgis to sources.list
RUN echo "deb     http://qgis.org/debian xenial main" >> /etc/apt/sources.list
RUN gpg --keyserver keyserver.ubuntu.com --recv DD45F6C3
RUN gpg --export --armor DD45F6C3 | apt-key add -
RUN apt-get -y update

#-------------Application Specific Stuff ----------------------------------------------------
RUN apt-get install -y python-simplejson xauth htop nano curl ntp ntpdate python-software-properties git wget unzip \
    apache2 libapache2-mod-fcgid php7.0 php7.0-cgi php7.0-curl php7.0-cli php7.0-sqlite php7.0-gd  php7.0-simplexml \
    php7.0-pgsql libapache2-mod-php7.0 qgis-server --force-yes
RUN a2dismod php7.0; a2enmod actions; a2enmod fcgid ; a2enmod ssl; a2enmod rewrite; a2enmod headers; a2enmod deflate; \
    a2enmod php7.0

# Config compression
ADD mod_deflate.conf /etc/apache2/conf.d/mod_deflate.conf
# Config php7
ADD php.conf /etc/apache2/conf.d/php.conf
# Remove the default mod_fcgid configuration file
RUN rm -v /etc/apache2/mods-enabled/fcgid.conf
# Copy a configuration file from the current directory
ADD fcgid.conf /etc/apache2/mods-enabled/fcgid.conf
# Open port 80 & mount /home 
EXPOSE 80
VOLUME /home

ADD apache2.conf /etc/apache2/apache2.conf
ADD 000-default.conf /etc/apache2/sites-available/000-default.conf
RUN rm /etc/apache2/sites-enabled/000-default.conf
RUN ln -s /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-enabled/000-default.conf
ADD fcgid.conf /etc/apache2/mods-available/fcgid.conf
ADD pg_service.conf /etc/pg_service.conf
# pg service file
ENV PGSERVICEFILE /etc/pg_service.conf

#-----------------Install lizmap-web-client-------------------------------
# Download & unzip
ADD https://github.com/3liz/lizmap-web-client/archive/3.0.3.zip /var/www/
# unzip lizmap 3.0.3
RUN unzip /var/www/3.0.3.zip -d /var/www/
RUN mv /var/www/lizmap-web-client-3.0.3/ /var/www/websig/
RUN rm /var/www/3.0.3.zip

# Set rights & active config
RUN chmod +x /var/www/websig/lizmap/install/set_rights.sh
RUN /var/www/websig/lizmap/install/set_rights.sh www-data www-data
RUN cp /var/www/websig/lizmap/var/config/lizmapConfig.ini.php.dist /var/www/websig/lizmap/var/config/lizmapConfig.ini.php
RUN cp /var/www/websig/lizmap/var/config/localconfig.ini.php.dist /var/www/websig/lizmap/var/config/localconfig.ini.php
RUN cp /var/www/websig/lizmap/var/config/profiles.ini.php.dist /var/www/websig/lizmap/var/config/profiles.ini.php

#  Installer
RUN php /var/www/websig/lizmap/install/installer.php

# Set rights
RUN chown :www-data /var/www/websig/lizmap/www -R
RUN chmod 775 /var/www/websig/lizmap/www -R
RUN chown :www-data /var/www/websig/lizmap/var -R
RUN chmod 775 /var/www/websig/lizmap/var -R
RUN cp -avr /var/www/websig/lizmap/var var/www/websig/lizmap/var_install

# Link volume lizmap_config persistent data host
VOLUME  /var/www/websig/lizmap/var
VOLUME  /tmp
# Add a redirection for just call the ip
ADD index.html /var/www/index.html

# Add start.sh on first install, generate config file: ~/lizmap/var
ADD start.sh /start.sh
RUN chmod 0755 /start.sh
# Now launch apache in the foreground
CMD /start.sh
