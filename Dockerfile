FROM ubuntu:latest

# Install apache, PHP, and supplimentary programs. openssh-server, curl, and lynx-cur are for debugging the container.
RUN  apt-get update \
  && apt-get install -y wget
RUN apt-get install -y software-properties-common
RUN add-apt-repository ppa:ondrej/php
RUN DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends \
    apt-utils \
    curl \
    # Install apache
    apache2 \
	software-properties-common \
    # Install php 7.2
    libapache2-mod-php7.2 \
	php7.2 \
	php7.2-common \
	php7.2-mbstring \
	php7.2-xmlrpc \
	php7.2-sqlite3 \
	php7.2-soap \
	php7.2-gd \
	php7.2-xml \
	php7.2-cli \
	php7.2-tidy \
	php7.2-intl \
	php7.2-json \
	php7.2-curl \
	php7.2-zip \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Enable apache mods.
RUN a2enmod php7.2
RUN a2enmod rewrite

RUN service apache2 restart

# Update the PHP.ini file, enable <? ?> tags and quieten logging.
RUN sed -i "s/short_open_tag = Off/short_open_tag = On/" /etc/php/7.2/apache2/php.ini
RUN sed -i "s/error_reporting = .*$/error_reporting = E_ERROR | E_WARNING | E_PARSE/" /etc/php/7.2/apache2/php.ini

# Manually set up the apache environment variables
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_PID_FILE /var/run/apache2.pid

# Expose apache.
EXPOSE 80

# Copy this repo into place.
RUN wget -q http://download.dokuwiki.org/src/dokuwiki/dokuwiki-stable.tgz -P /tmp 
RUN mkdir -p /var/www/html/dokuwiki 
RUN tar -xzf /tmp/dokuwiki-stable.tgz -C /var/www/html/dokuwiki --strip-components 1
RUN chown -R www-data:www-data /var/www/html/dokuwiki/
RUN chmod -R 755 /var/www/html/dokuwiki

# Update the default apache site with the config we created.
ADD dokuwiki.conf /etc/apache2/sites-available/

RUN a2ensite dokuwiki.conf
RUN a2enmod rewrite
RUN service apache2 restart

RUN a2dissite 000-default.conf
RUN a2enmod rewrite
RUN service apache2 restart

# By default start up apache in the foreground, override with /bin/bash for interative.
CMD /usr/sbin/apache2ctl -D FOREGROUND