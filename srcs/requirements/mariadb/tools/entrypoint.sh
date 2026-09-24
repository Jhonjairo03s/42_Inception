#!/bin/sh

DATADIR="/var/lib/mysql/mysql"

if [ ! -d $DATADIR ];
then
	/usr/bin/mariadb-install-db --user=mysql --datadir=/var/lib/mysql --basedir=/usr

	# demonio en segundo plano
	/usr/bin/mariadbd --user=mysql --datadir=/var/lib/mysql &

	while [ ! -e /run/mysqld/mysqld.sock ];
	do
		sleep 1
	done

	# creación base de datos
	/usr/bin/mariadb -e "CREATE DATABASE $MYSQL_DATABASE;"
	/usr/bin/mariadb -e "CREATE USER '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';"
	/usr/bin/mariadb -e "GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO '$MYSQL_USER'@'%';"
	/usr/bin/mariadb -e "GRANT ALL PRIVILEGES on *.* to 'root'@'%' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD';"
	/usr/bin/mariadb -e "FLUSH PRIVILEGES;"

	# https://mariadb.com/docs/server/clients-and-utilities/administrative-tools/mariadb-admin
	# kill -SIGTERM pid-of-mariadbd-process
	/usr/bin/mariadb-admin shutdown
fi

# arranque en primer plano
exec /usr/bin/mariadbd --user=mysql --datadir=/var/lib/mysql
