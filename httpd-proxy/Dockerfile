FROM ubuntu:16.04
MAINTAINER adrien.cheype@ird.fr

RUN apt update && apt install -y apache2 apache2-utils vim && apt clean
RUN a2enmod proxy_http proxy_ajp proxy_balancer proxy_wstunnel proxy_html xml2enc rewrite headers
RUN a2dissite 000-default

ENV APACHE_UID 33
ENV APACHE_GID 33
ENV APACHE_RUN_USER #${APACHE_UID}
ENV APACHE_RUN_GROUP #${APACHE_GID}
ENV APACHE_PORT 80
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_PID_FILE /var/run/apache2.pid
ENV APACHE_LOCK_DIR /var/lock/apache2

RUN mkdir -p /var/lock/apache2; chown $APACHE_UID /var/lock/apache2
RUN sed -i 's@Listen 80@Listen '"$APACHE_PORT"'@' /etc/apache2/ports.conf
RUN sed -i 's@ErrorLog ${APACHE_LOG_DIR}/error.log@ErrorLog /dev/stderr@' /etc/apache2/apache2.conf
#RUN sed -i 's@#ServerName www.example.com@ServerName localhost@' /etc/apache2/apache2.conf
RUN sed -i 's@Require all granted@Require all denied@' /etc/apache2/apache2.conf

COPY proxy.conf /etc/apache2/conf-available/
RUN a2enconf proxy

EXPOSE $APACHE_PORT

CMD ["apache2","-D","FOREGROUND"]
