# Use the official PHP image with Apache
FROM php:8.2-apache

# Set working directory
WORKDIR /var/www/html

# Copy the current directory contents into the container at /var/www/html
COPY . /var/www/html

# Install dependencies
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    && docker-php-ext-install pdo pdo_mysql

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Install PHP dependencies
RUN composer install

# Update Apache to listen on port 8000
RUN sed -i 's/Listen 80/Listen 8000/' /etc/apache2/ports.conf
RUN sed -i 's/<VirtualHost *:80>/<VirtualHost *:8000>/' /etc/apache2/sites-available/000-default.conf

# Expose port 8000
EXPOSE 8000

# Start the Apache server
CMD ["apache2-foreground"]
