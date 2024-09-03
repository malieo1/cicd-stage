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
    libzip-dev \
    && docker-php-ext-install pdo pdo_mysql zip \
    && a2enmod rewrite

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer
ENV COMPOSER_ALLOW_SUPERUSER=1

# Install PHP dependencies
RUN composer install --no-scripts --no-autoloader --prefer-dist

# Set correct permissions for Symfony directories
RUN chown -R www-data:www-data /var/www/html/var /var/www/html/public \
    && chmod -R 755 /var/www/html/var /var/www/html/public

# Update Apache to listen on port 8000
RUN sed -i 's/Listen 80/Listen 8000/' /etc/apache2/ports.conf

# Update Apache VirtualHost to serve Symfony public directory
RUN sed -i 's|<VirtualHost *:80>|<VirtualHost *:8000>|' /etc/apache2/sites-available/000-default.conf \
    && sed -i 's|DocumentRoot /var/www/html|DocumentRoot /var/www/html/public|' /etc/apache2/sites-available/000-default.conf

# Ensure correct Directory settings
RUN echo '<Directory /var/www/html/public>' >> /etc/apache2/sites-available/000-default.conf \
    && echo '    AllowOverride All' >> /etc/apache2/sites-available/000-default.conf \
    && echo '    Require all granted' >> /etc/apache2/sites-available/000-default.conf \
    && echo '</Directory>' >> /etc/apache2/sites-available/000-default.conf

# Expose port 8000
EXPOSE 8000

# Run Apache in the foreground
CMD ["apache2-foreground"]

