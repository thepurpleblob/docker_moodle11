FROM php:7.4-fpm

RUN apt update && apt install -y zlib1g-dev libpng-dev libxml2-dev libzip-dev libxslt-dev 
RUN docker-php-ext-install pdo pdo_mysql mysqli gd xmlrpc soap intl zip xsl
RUN pecl install -o -f redis &&  rm -rf /tmp/pear &&  docker-php-ext-enable redis

RUN mv "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini"