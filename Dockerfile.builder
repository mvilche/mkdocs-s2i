FROM alpine:3.12

LABEL autor="Martin Vilche <mfvilche@gmail.com>" \
      io.k8s.description="Generado documentacion mkdocs" \
      io.k8s.display-name="Java Applications" \
      io.openshift.tags="builder,java,maven" \
      io.openshift.expose-services="8080,8009,8443,8778" \
      org.jboss.deployments-dir="/opt/wildfly/standalone/deployments" \
      io.openshift.s2i.scripts-url="image:///usr/libexec/s2i"

RUN apk add --update --no-cache findutils tzdata shadow apache2 wget bash python3 python3-dev py3-pip gcc musl-dev curl rsync \
tzdata git busybox-extras nodejs msttcorefonts-installer fontconfig \
which openssh shadow busybox-suid coreutils tzdata && pip install mkdocs && apk del --purge  musl-dev python3-dev gcc && \
    update-ms-fonts && \
    fc-cache -f 

RUN  sed -i -e "s/^Listen 80/Listen 8080/" /etc/apache2/httpd.conf && \
sed -ri -e 's!^(\s*ErrorLog)\s+\S+!\1 /proc/self/fd/2!g' /etc/apache2/httpd.conf && \
rm -rf /var/www/localhost/htdocs/* && mkdir -p /run/apache2 && rm -rf /var/cache/apk/* /etc/localtime  

COPY security.conf /etc/apache2/conf.d/security.conf

COPY s2i/bin/ /usr/libexec/s2i

RUN mkdir -p /var/www/html /usr/share/httpd && usermod -u 1001 apache && usermod -aG 0 apache && touch /etc/localtime /etc/timezone && \
chown -R 1001 /opt /etc/apache2 /usr/share/apache2/ /var/log/apache2 /usr/share/httpd /usr/lib/apache2 /var/www/html /var/www/localhost/htdocs/ /var/www/logs/ /run/apache2 /etc/timezone /etc/localtime /usr/libexec/s2i && \
chgrp -R 0 /opt /etc/apache2 /usr/share/apache2/ /usr/share/httpd /var/log/apache2 /usr/lib/apache2 /var/www/html /var/www/localhost/htdocs/ /var/www/logs/ /run/apache2 /etc/timezone /etc/localtime /usr/libexec/s2i && \
chmod -R g=u /opt /etc/apache2 /usr/share/apache2/ /var/log/apache2 /usr/share/httpd /usr/lib/apache2 /var/www/html /var/www/localhost/htdocs/ /var/www/logs/ /run/apache2 /etc/timezone /etc/localtime /usr/libexec/s2i && \
chmod +x /usr/libexec/s2i/*

WORKDIR /var/www/html

ENV HOME=/usr/share/httpd \
APACHE_CONFIGDIR=/etc/apache2

USER 1001:0

EXPOSE 8080

CMD ["/usr/libexec/s2i/run"]

