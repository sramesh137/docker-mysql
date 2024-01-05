#!/bin/bash

# # Wait for MySQL master to be ready
# until mysql -h$MYSQL_MASTER_HOST -P$MYSQL_MASTER_PORT -uroot -p$MYSQL_ROOT_PASSWORD -e "SELECT 1"; do
#     >&2 echo "MySQL master is unavailable - sleeping"
#     sleep 1
# done

# Create main_db database
mysql -u root -p$MYSQL_ROOT_PASSWORD -e "CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE;"

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

