# Use the official PHP image with Apache
FROM php:8.3-apache

# Set the working directory
WORKDIR /var/www/html

# Enable Apache mod_rewrite
RUN a2enmod rewrite

RUN apt-get update -y && apt-get install -y unzip zip 

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Create Laravel project
RUN composer create-project laravel/laravel example-app

# Set the working directory to the Laravel project
WORKDIR /var/www/html/example-app

# Copy Apache vhost configuration
COPY ./vhost.conf /etc/apache2/sites-available/000-default.conf

# Change ownership of the Laravel project files
RUN chown -R www-data:www-data /var/www/html/example-app

# Ensure storage and cache directories are writable
RUN chown -R www-data:www-data /var/www/html/example-app/storage /var/www/html/example-app/bootstrap/cache

# Expose port 80
EXPOSE 80

# Start Apache server
CMD ["apache2-foreground"]

#docker build -t my-laravel-app .
#docker run -p 8000:80 my-laravel-app
