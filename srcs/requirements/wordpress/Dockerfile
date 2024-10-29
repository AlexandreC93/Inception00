FROM wordpress:php7.4-fpm-alpine

# Installer les extensions PHP nécessaires
RUN docker-php-ext-install mysqli

CMD ["php-fpm"]