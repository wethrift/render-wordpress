# You can change this to a different version of Wordpress available at
# https://hub.docker.com/_/wordpress
FROM wordpress:6.2-php8.0-apache

RUN apt-get update && apt-get install -y magic-wormhole

# Enable verbose error reporting for PHP
RUN echo 'error_reporting = E_ALL' >> /usr/local/etc/php/conf.d/error_reporting.ini
RUN echo 'display_errors = On' >> /usr/local/etc/php/conf.d/error_reporting.ini
RUN echo 'display_startup_errors = On' >> /usr/local/etc/php/conf.d/error_reporting.ini

# Enable Apache's rewrite, headers, and SSL modules
RUN a2enmod rewrite headers ssl

# Enable verbose logging for Apache
RUN sed -i 's/LogLevel warn/LogLevel debug/' /etc/apache2/apache2.conf
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf

RUN usermod -s /bin/bash www-data

# Copy Wordpress files as root user
USER root
COPY --chown=www-data:www-data --from=wordpress:6.2-php8.0-apache /usr/src/wordpress /var/www/html

# Set appropriate permissions
RUN chown -R www-data:www-data /var/www
RUN chmod -R 755 /var/www

# Switch back to www-data user
USER www-data:www-data