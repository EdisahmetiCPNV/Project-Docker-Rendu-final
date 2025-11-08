#!/bin/bash

# Wait for MySQL to be ready
until mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e "SHOW DATABASES;"; do
  echo "Waiting for MySQL to be ready..."
  sleep 2
done

# Create database if it doesn't exist
mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e "CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE;"

# Create user if it doesn't exist
mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e "CREATE USER IF NOT EXISTS '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';"

# Grant privileges to the user
mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e "GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO '$MYSQL_USER'@'%';"

# Flush privileges to apply changes
mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e "FLUSH PRIVILEGES;"

echo "MySQL database and user initialized."
