FROM phusion/baseimage:0.9.15

ENV HOME /root
COPY . /build
WORKDIR /tmp

# base env
RUN apt-get update
RUN apt-get install -y --force-yes mysql-client php5-cli php5-mysql php5-sqlite php5-curl php5-gd php5-mcrypt php5-intl git curl make telnet

RUN ln -s /etc/php5/mods-available/mcrypt.ini /etc/php5/cli/conf.d/20-mcrypt.ini

# nodejs
RUN curl -sL https://deb.nodesource.com/setup | bash -
RUN apt-get install -y --force-yes nodejs

# composer
RUN curl -sS https://getcomposer.org/installer | php
RUN mv composer.phar /usr/local/bin/composer

RUN echo "Host bitbucket.org\n\tStrictHostKeyChecking no\n" >> ~/.ssh/config
RUN echo "Host github.com\n\tStrictHostKeyChecking no\n" >> ~/.ssh/config


EXPOSE 8000 8001 8002 8003 8004 8005 9000 9001 9002 9003 9004 9005

WORKDIR /data
#CMD [ "/usr/bin/php", "-S 127.0.0.1:8000 -t ./public" ]
