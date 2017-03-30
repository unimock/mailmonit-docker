FROM alpine:latest

MAINTAINER <unimock@gate-m.de>
#
# https://github.com/hokstadconsulting/docker-postfix
# Log to stdout
# https://hub.docker.com/r/alezzandro/postfix/~/dockerfile/
#
RUN apk add --update postfix supervisor nginx bash perl rsyslog dcron rsync tree
RUN wget http://caspian.dotconf.net/menu/Software/SendEmail/sendEmail-v156.zip \
    && unzip sendEmail-v156.zip sendEmail.pl && rm -f sendEmail-v156.zip
RUN mv /sendEmail.pl /usr/bin/sendemail
RUN  rm -rf /var/cache/apk/* /tmp/* /var/tmp/*
############################################################################################
#
# cron
#
RUN mkdir -p /var/log/cron && mkdir -m 0644 -p /var/spool/cron/crontabs && touch /var/log/cron/cron.log && mkdir -m 0644 -p /etc/cron.d
RUN echo '#* * * * * /home/joe/myscript >> /home/log/myscript.log 2>&1'                 >  /etc/cron.d/template
RUN echo '# An empty line is required at the end of this file for a valid cron file.'   >> /etc/cron.d/template
############################################################################################
#
# rsyslog
#
ADD rsyslog/rsyslog.conf /etc/rsyslog.conf
############################################################################################
#
# nginx
#

COPY ./nginx/default.conf /etc/nginx/conf.d/default.conf
COPY ./nginx/nginx.conf   /etc/nginx/nginx.conf

RUN mkdir -p /run/nginx/ /var/lib/nginx
RUN chown -R nginx:www-data /var/lib/nginx /run/nginx/
RUN cp -va /var/lib/nginx/html/* /var/www/localhost/htdocs/
EXPOSE 80 443
############################################################################################
#
# postfix
#
RUN mkdir -p /var/spool/mail/vhosts
RUN chown root /var/spool/postfix
RUN chown -R vmail:postdrop /var/spool/mail/vhosts
ADD postfix/main.cf /etc/postfix/main.cf
RUN echo "echo-request:   \"|/usr/local/bin/mailmonit.sh\"" > /etc/postfix/aliases
RUN chmod g-w /etc/postfix/*
EXPOSE 25 587
VOLUME /var/spool/mail/vhosts
############################################################################################
#
# webproc with mailmonit
#
RUN mkdir -p /usr/local/sbin
COPY ./webproc/webproc       /usr/local/sbin/
COPY ./webproc/webproc.toml  /etc/webproc.toml
COPY ./webproc/webproc.toml  /etc/webproc.toml
COPY ./webproc/mailmonit.dat /etc/mailmonit.dat
############################################################################################
#
# docker-extensions
#
RUN mkdir -p /usr/local/bin
COPY ./bin/*             /usr/local/bin/
RUN chmod a+x /usr/local/bin/*
RUN chmod a+x /usr/local/sbin/* 2>/dev/null
############################################################################################
#
# supervisor
#
RUN echo ". /etc/profile" > /root/.bashrc
RUN echo "export PS1='\H:\w\\$ '" >> /etc/profile
RUN echo "alias ll='ls -alF'"     >> /etc/profile
RUN echo 'export TERM="xterm"'    >> /etc/profile
#
# establisch supervisord
#
ADD /supervisor /etc/supervisor
RUN ln -sf /etc/supervisor/supervisord.conf /etc/supervisord.conf
RUN mkdir -p /var/log/supervisor && chmod a+rw var/log/supervisor
# link /etc/init.d/ startup scripts to supervisor
RUN ( cd /etc/supervisor/services.d ; ls * | while read i; do mv /etc/init.d/$i /etc/init.d/$i-orig ;  ln -sf /etc/supervisor/super-init.sh /etc/init.d/$i ; done 2>/dev/null )
RUN ln -sf    /etc/supervisor/systemctl /bin/systemctl
RUN chmod a+x /etc/supervisor/* /etc/supervisor/*.d/*
COPY /supervisor/invoke-rc.d /usr/sbin/invoke-rc.d
COPY /supervisor/reload      /sbin/reload
RUN  chmod a+x /sbin/reload /usr/sbin/invoke-rc.d
EXPOSE 9001
############################################################################################
#
# create directory for service volume
#
RUN mkdir -p /service ; chmod a+rwx /service
############################################################################################
#
# startup script
#
ADD ./start.sh /start.sh
RUN chmod 755 /start.sh
CMD ["/start.sh"]
