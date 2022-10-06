#!/bin/bash

chown -R mysql:mysql /var/lib/mysql

mysql_install_db --user=mysql --ldata=/var/lib/mysql > /dev/null

#Create user and give all privileges, if not wordpress can't access to DB
tfile=`mktemp`
if [ ! -f "$tfile" ]; then
    return 1
fi

cat << EOF > $tfile
USE mysql;
FLUSH PRIVILEGES ;
CREATE USER 'root'@'%' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD';
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' identified by '$MYSQL_ROOT_PASSWORD' WITH GRANT OPTION ;
FLUSH PRIVILEGES ;
EOF

#Create database and give all privileges to the user, if not wordpress can't access to DB
if [ "$MYSQL_DATABASE" != "" ]; then
    echo "[i] Creating database: $MYSQL_DATABASE"
	if [ "$MYSQL_CHARSET" != "" ] && [ "$MYSQL_COLLATION" != "" ]; then
		echo "[i] with character set [$MYSQL_CHARSET] and collation [$MYSQL_COLLATION]"
		echo "CREATE DATABASE IF NOT EXISTS \`$MYSQL_DATABASE\` CHARACTER SET $MYSQL_CHARSET COLLATE $MYSQL_COLLATION;" >> $tfile
	else
		echo "[i] with character set: 'utf8' and collation: 'utf8_general_ci'"
		echo "CREATE DATABASE IF NOT EXISTS \`$MYSQL_DATABASE\` CHARACTER SET utf8 COLLATE utf8_general_ci;" >> $tfile
	fi

 if [ "$MYSQL_USER" != "" ]; then
	echo "[i] Creating user: $MYSQL_USER with password $MYSQL_PASSWORD"
	echo "GRANT ALL ON \`$MYSQL_DATABASE\`.* to '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';" >> $tfile
    fi
fi

#Prevent login user without password
echo "DELETE FROM mysql.user WHERE user = '' AND host = 'localhost';" >> $tfile
echo "DELETE FROM mysql.user WHERE user = 'root' AND host = 'localhost';" >> $tfile
echo "FLUSH PRIVILEGES;" >> $tfile


#Execute the commands in MYSQL 
/usr/bin/mysqld --user=mysql --bootstrap --verbose=0 --skip-name-resolve --skip-networking=0 < $tfile
rm -f $tfile

# mysqld --user=root

exec /usr/bin/mysqld --user=root --console --skip-name-resolve --skip-networking=0
