#!/bin/bash

# Wait for MySQL master to be ready
# until mysql -h$MYSQL_MASTER_HOST -P$MYSQL_MASTER_PORT -uroot -p$MYSQL_ROOT_PASSWORD -e "SELECT 1"; do
#     >&2 echo "MySQL master is unavailable - sleeping"
#     sleep 1
# done

# # Check if main_db database exists on the slave
# DB_EXISTS=$(mysql -uroot -p$MYSQL_ROOT_PASSWORD -e "SHOW DATABASES LIKE '$MYSQL_DATABASE';" --skip-column-names)

# # If main_db doesn't exist on the slave, create it
# if [ -z "$DB_EXISTS" ]; then
#     mysql -uroot -p$MYSQL_ROOT_PASSWORD -e "CREATE DATABASE $MYSQL_DATABASE;"
# fi

# Check if root user exists on the slave
# ROOT_EXISTS=$(mysql -uroot -p$MYSQL_ROOT_PASSWORD -h127.0.0.1 -e "SELECT user FROM mysql.user WHERE user='root';" --skip-column-names)

# If root user doesn't exist on the slave, create it and grant privileges
# if [ -z "$ROOT_EXISTS" ]; then
#     mysql -uroot -p$MYSQL_ROOT_PASSWORD -e "CREATE USER 'root'@'%' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD';"
#     mysql -uroot -p$MYSQL_ROOT_PASSWORD -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;"
#     mysql -uroot -p$MYSQL_ROOT_PASSWORD -e "FLUSH PRIVILEGES;"
# fi

# Create a MySQL main_user with all privileges
mysql -uroot -p$MYSQL_ROOT_PASSWORD -e "CREATE USER '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';"
mysql -uroot -p$MYSQL_ROOT_PASSWORD -e "GRANT ALL PRIVILEGES ON *.* TO '$MYSQL_USER'@'%' WITH GRANT OPTION;"
mysql -uroot -p$MYSQL_ROOT_PASSWORD -e "FLUSH PRIVILEGES;"

# Grant additional privileges if needed using the new user
# mysql -uroot -p$MYSQL_ROOT_PASSWORD -e "GRANT ... ON ... TO '$MYSQL_USER'@'%';"

# Configure replication
mysql -uroot -p$MYSQL_ROOT_PASSWORD -e "CHANGE MASTER TO MASTER_HOST='$MYSQL_MASTER_HOST', MASTER_PORT=$MYSQL_MASTER_PORT, MASTER_USER='$MYSQL_REPL_USER', MASTER_PASSWORD='$MYSQL_REPL_PASSWORD', MASTER_LOG_FILE='$MYSQL_MASTER_LOG_FILE', MASTER_LOG_POS=$MYSQL_MASTER_LOG_POS;"

# Start the slave
mysql -uroot -p$MYSQL_ROOT_PASSWORD -e "START SLAVE;"

# Display slave status
mysql -uroot -p$MYSQL_ROOT_PASSWORD -e "SHOW SLAVE STATUS\G;"
