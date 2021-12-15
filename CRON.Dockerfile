FROM php:7.4-fpm

RUN apt-get update && apt-get install -y cron zlib1g-dev libpng-dev libxml2-dev libzip-dev libxslt-dev 
RUN docker-php-ext-install pdo pdo_mysql mysqli gd xmlrpc soap intl zip xsl opcache
RUN pecl install -o -f redis &&  rm -rf /tmp/pear &&  docker-php-ext-enable redis

RUN mv "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini"

COPY ./moodlephp.ini "$PHP_INI_DIR/conf.d/moodlephp.ini"
COPY ./moodlephpfpm.conf "/usr/local/etc/php-fpm.d"

# Create cron log file
RUN touch /var/log/schedule.log
RUN chmod 0777 /var/log/schedule.log

# Add crontab file
ADD scheduler /etc/cron.d/scheduler

# Run cron
RUN crontab /etc/cron.d/scheduler
CMD ["cron", "-f"]