FROM php:5.6-apache
MAINTAINER Hannes de Jager <hannes.de.jager@gmail.com>

ENV BASE_URL http://localhost/
COPY web/ /var/www/html/
RUN chown -R www-data:www-data /var/www/html

# These files contains deployment specific configuration
ONBUILD COPY database.php config.php email.php /var/www/html/bamboo_system_files/application/config/

# 'apache2ctl -M' & 'php -m' on a server running bambooinvoice led me to this.
RUN docker-php-ext-install mysql pdo_mysql 
