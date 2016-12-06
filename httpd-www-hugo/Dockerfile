FROM ubuntu:16.04
MAINTAINER adrien.cheype@ird.fr

ENV APACHE_UID 33
ENV APACHE_GID 33
ENV APACHE_RUN_USER #${APACHE_UID}
ENV APACHE_RUN_GROUP #${APACHE_GID}
ENV APACHE_PORT 80
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_PID_FILE /var/run/apache2.pid
ENV APACHE_LOCK_DIR /var/lock/apache2

ENV HUGO_VERSION=0.17
RUN apt update && apt install -y apache2 apache2-utils vim wget git && apt clean
RUN a2enmod authnz_ldap cgi

RUN cd /tmp/ && \
  wget https://github.com/spf13/hugo/releases/download/v${HUGO_VERSION}/hugo_${HUGO_VERSION}_Linux-64bit.tar.gz && \
  tar xzf hugo_${HUGO_VERSION}_Linux-64bit.tar.gz && \
  rm -r hugo_${HUGO_VERSION}_Linux-64bit.tar.gz && \
  mv hugo*/hugo* /usr/bin/hugo

RUN mkdir -p /var/lock/apache2 && chown $APACHE_UID:$APACHE_GID /var/lock/apache2
RUN sed -i 's@Listen 80@Listen '"$APACHE_PORT"'@' /etc/apache2/ports.conf
RUN sed -i '1s/^/ServerName localhost\n/' /etc/apache2/sites-available/000-default.conf
#RUN sed -i 's@Require all granted@Require all denied@' /etc/apache2/apache2.conf

COPY serve-cgi-bin.conf /etc/apache2/conf-available/serve-cgi-bin.conf

RUN mkdir -p /home/www-hugo
RUN git -C /home/www-hugo clone https://github.com/acheype/data-pacifique-nea.git .
RUN chown -R $APACHE_UID:$APACHE_GID /home/www-hugo
RUN cd /home/www-hugo && hugo

COPY publish.sh /usr/lib/cgi-bin/
RUN chmod ug+x /usr/lib/cgi-bin/publish.sh && chown $APACHE_UID:$APACHE_GID /usr/lib/cgi-bin/publish.sh

VOLUME ["/var/www/html"]
VOLUME ["/home/hugo"]
EXPOSE $APACHE_PORT

CMD ["apache2","-D","FOREGROUND"]
