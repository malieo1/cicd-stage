# Use the official PHP image with Apache
FROM php:8.2-apache

# Install required PHP extensions
RUN apt-get update && apt-get install -y \
    libicu-dev \
    libzip-dev \
    zip \
    unzip \
    git \
    && docker-php-ext-install intl pdo pdo_mysql opcache zip

# Enable Apache mod_rewrite
RUN a2enmod rewrite

# Set the working directory to /var/www/html
WORKDIR /var/www/html

# Install Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Copy the application files to the working directory
COPY . /var/www/html

# Install Symfony PHP dependencies with Composer
RUN composer install --prefer-dist --optimize-autoloader

# Clear Symfony cache
RUN php bin/console cache:clear

# Set permissions for the entire web root
RUN chown -R www-data:www-data /var/www/html && \
    chmod -R 755 /var/www/html

# Set the correct DocumentRoot for Symfony's public directory
RUN sed -i 's|/var/www/html|/var/www/html/public|g' /etc/apache2/sites-available/000-default.conf

# Add DirectoryIndex directive to Apache configuration
RUN echo "DirectoryIndex index.php index.html" >> /etc/apache2/apache2.conf

# Expose the correct port
EXPOSE 80

# Start Apache in foreground
CMD ["apache2-foreground"]