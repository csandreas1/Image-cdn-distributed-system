# Use an official PHP runtime as a parent image
FROM php:8.3-fpm

# Set the working directory to /var/www/html
WORKDIR /var/www/html

# Install dependencies
RUN apt-get update && \
    apt-get install -y \
        libfreetype-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
        libzip-dev \
        unzip \
        mariadb-client \
        libicu-dev

# Install Xdebug
COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/bin/
RUN install-php-extensions xdebug zip pdo_mysql mysqli @composer intl

# Copy the current directory contents into the container at /var/www/html
COPY --chown=www-data:www-data  . /var/www/html

RUN	chmod o+w /var/www/html -R

RUN composer install
# Expose port 9000 and start php-fpm server
EXPOSE 9000
CMD ["php-fpm"]
