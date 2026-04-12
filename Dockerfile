FROM php:8.2-apache
RUN apt-get update && apt-get install -y \
    libpng-dev libjpeg-dev libwebp-dev \
    libfreetype6-dev libzip-dev unzip curl git \
    libicu-dev \
    ca-certificates \
    libcurl4-openssl-dev \
    && update-ca-certificates \
    && docker-php-ext-configure gd \
    --with-freetype --with-jpeg --with-webp \
    && docker-php-ext-install gd pdo pdo_mysql zip exif opcache intl curl
RUN a2enmod rewrite
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer
COPY . /var/www/html/
WORKDIR /var/www/html/app
RUN composer install --no-dev --optimize-autoloader
WORKDIR /var/www/html
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html
RUN echo "extension=pdo_mysql" >> /usr/local/etc/php/conf.d/custom.ini && \
    echo "mysqli.ssl_ca=/etc/ssl/certs/ca-certificates.crt" >> /usr/local/etc/php/conf.d/custom.ini
EXPOSE 80
