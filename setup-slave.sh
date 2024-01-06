#!/bin/bash

# Inside setup-slave.sh
echo "Setting up slave..."

# Create main_db database
mysql -u root -p$MYSQL_ROOT_PASSWORD -e "CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE;"


# Create a MySQL main_user with all privileges
mysql -uroot -p$MYSQL_ROOT_PASSWORD -e "CREATE USER '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';"
mysql -uroot -p$MYSQL_ROOT_PASSWORD -e "GRANT ALL PRIVILEGES ON *.* TO '$MYSQL_USER'@'%' WITH GRANT OPTION;"
mysql -uroot -p$MYSQL_ROOT_PASSWORD -e "FLUSH PRIVILEGES;"

# Configure replication
# mysql -uroot -p$MYSQL_ROOT_PASSWORD -e "CHANGE MASTER TO MASTER_HOST='$MYSQL_MASTER_HOST', MASTER_PORT=$MYSQL_MASTER_PORT, MASTER_USER='$MYSQL_REPL_USER', MASTER_PASSWORD='$MYSQL_REPL_PASSWORD', MASTER_LOG_FILE='$MYSQL_MASTER_LOG_FILE', MASTER_LOG_POS=$MYSQL_MASTER_LOG_POS;"

# Print the content of the replication shared script
echo "printing the output of the replication script"
cat /shared/master_status.sql


# Print a message to indicate the start of the shared script execution
echo "Running shared script from setup-slave.sh"


# Invoke the configured replication shared script
# /shared/shared_script.sh
/shared/master_status.sql

# Start the slave
mysql -uroot -p$MYSQL_ROOT_PASSWORD -e "START SLAVE;"

# Display slave status
mysql -uroot -p$MYSQL_ROOT_PASSWORD -e "SHOW SLAVE STATUS\G;"