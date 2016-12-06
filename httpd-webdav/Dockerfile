FROM ubuntu:16.04
MAINTAINER adrien.cheype@ird.fr

RUN apt update && apt install -y apache2 apache2-utils vim && apt clean
RUN a2enmod dav dav_fs dav_lock authnz_ldap
RUN a2dissite 000-default

ENV SERVER_NAME geodata.ird.nc
ENV APACHE_UID 33
ENV APACHE_GID 33
ENV APACHE_RUN_USER #${APACHE_UID}
ENV APACHE_RUN_GROUP #${APACHE_GID}
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_PID_FILE /var/run/apache2.pid
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_RUN_DIR /var/run/apache2
ENV APACHE_PORT 80

RUN mkdir -p /var/lock/apache2; chown $APACHE_UID /var/lock/apache2
RUN sed -i 's@Listen 80@Listen '"$APACHE_PORT"'@' /etc/apache2/ports.conf

COPY cacert.pem /etc/apache2/
COPY webdav.conf /etc/apache2/sites-available/webdav.conf
RUN if [ -n "$SERVER_NAME" ]; then sed -i 's@#ServerName SERVERNAME@ServerName '"$SERVER_NAME"'@' /etc/apache2/sites-available/webdav.conf;fi
RUN a2ensite webdav

RUN touch /etc/apache2/webdav.password
RUN chown root:${APACHE_GID} /etc/apache2/webdav.password
RUN chmod 640 /etc/apache2/webdav.password

VOLUME ["/var/webdav"]
EXPOSE $APACHE_PORT

CMD ["apache2","-D","FOREGROUND"]
