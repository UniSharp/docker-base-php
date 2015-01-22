FROM phusion/baseimage:0.9.15

ENV HOME /root
COPY . /build
WORKDIR /tmp

# base env
RUN add-apt-repository -y ppa:nginx/stable
RUN apt-get update
RUN apt-get install -y --force-yes mysql-client php5-cli php5-mysql php5-sqlite php5-curl php5-gd php5-mcrypt php5-intl git curl make telnet nginx php5-fpm

RUN ln -s /etc/php5/mods-available/mcrypt.ini /etc/php5/cli/conf.d/20-mcrypt.ini

# nodejs
RUN curl -sL https://deb.nodesource.com/setup | bash -
RUN apt-get install -y --force-yes nodejs

# composer
RUN curl -sS https://getcomposer.org/installer | php
RUN mv composer.phar /usr/local/bin/composer

RUN echo "Host bitbucket.org\n\tStrictHostKeyChecking no\n" >> ~/.ssh/config
RUN echo "Host github.com\n\tStrictHostKeyChecking no\n" >> ~/.ssh/config


EXPOSE 8000 80


RUN echo "daemon off;" >> /etc/nginx/nginx.conf
RUN sed -i "s/;date.timezone =.*/date.timezone = UTC/" /etc/php5/fpm/php.ini
RUN sed -i "s/;date.timezone =.*/date.timezone = UTC/" /etc/php5/cli/php.ini
RUN sed -i -e "s/;daemonize\s*=\s*yes/daemonize = no/g" /etc/php5/fpm/php-fpm.conf
RUN sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" /etc/php5/fpm/php.ini


#RUN mkdir -p /var/www
ADD _nginx/default /etc/nginx/sites-available/default
RUN mkdir /etc/service/nginx
ADD _nginx/nginx.sh /etc/service/nginx/run
RUN chmod +x /etc/service/nginx/run
RUN mkdir /etc/service/phpfpm
ADD _nginx/phpfpm.sh /etc/service/phpfpm/run
RUN chmod +x /etc/service/phpfpm/run

#CMD [ "/usr/bin/php", "-S 127.0.0.1:8000 -t ./public" ]
WORKDIR /data
CMD ["/sbin/my_init"]
