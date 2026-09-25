#!/bin/sh

mkdir -p /var/www/html && cd /var/www/html

if [ ! -f "wp-config.php" ];
then
	# https://developer.wordpress.org/cli/commands/
	/usr/local/bin/wp core download --allow-root

	/usr/local/bin/wp config create --dbname=$MYSQL_DATABASE --dbuser=$MYSQL_USER --dbpass=$MYSQL_PASSWORD --dbhost=mariadb --allow-root

	/usr/local/bin/wp core install --url=$DOMAIN_NAME --title=Inception --admin_user=$WP_ADMIN_USER --admin_password=$WP_ADMIN_PASSWORD --admin_email=$WP_ADMIN_EMAIL --allow-root

	/usr/local/bin/wp user create $WP_USER $WP_EMAIL --user_pass=$WP_PASSWORD --allow-root
fi

# Demonio se fuerza a que vaya a primer plano
exec /usr/sbin/php-fpm85 -F
