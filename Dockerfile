# Base PHP + Apache image
FROM php:8.2-apache

# Install MySQL extensions required by the application
RUN docker-php-ext-install mysqli pdo pdo_mysql

# Copy PHP application
COPY ./Apps /var/www/html

# Expose HTTP
EXPOSE 80