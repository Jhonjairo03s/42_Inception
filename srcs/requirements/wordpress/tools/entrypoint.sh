#!/bin/sh

mkdir -p /var/www/html && cd /var/www/html

if [ ! -f "wp-settings.php" ];
then
	php85 -d memory_limit=512M /usr/local/bin/wp core download --allow-root
fi

sleep 10

if [ ! -f "wp-config.php" ];
then
	# https://developer.wordpress.org/cli/commands/
	#php85 -d memory_limit=512M /usr/local/bin/wp core download --allow-root

	sleep 10

	/usr/local/bin/wp config create --dbname=$MYSQL_DATABASE --dbuser=$MYSQL_USER --dbpass=$MYSQL_PASSWORD --dbhost=mariadb --allow-root
	/usr/local/bin/wp core install --url=$DOMAIN_NAME --title=Inception --admin_user=$WP_ADMIN_USER --admin_password=$WP_ADMIN_PASSWORD --admin_email=$WP_ADMIN_EMAIL --allow-root

	/usr/local/bin/wp config set WP_REDIS_HOST 'redis' --allow-root
	/usr/local/bin/wp config set WP_REDIS_PORT 6379 --raw --allow-root
	/usr/local/bin/wp plugin install redis-cache --activate --allow-root
	# Encender el motor de caché
	wp redis enable --allow-root

	/usr/local/bin/wp user create $WP_USER $WP_EMAIL --user_pass=$WP_PASSWORD --allow-root
fi

# Cambiar la propiedad de todos los archivos al usuario del servidor web
chown -R nobody:nobody /var/www/html

# Demonio se fuerza a que vaya a primer plano
exec /usr/sbin/php-fpm85 -F
