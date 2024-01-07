#!/bin/bash

# Inside setup-slave.sh
echo "Setting up slave..."

# Create main_db database
mysql -u root -p$MYSQL_ROOT_PASSWORD -e "CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE;"


# Create a MySQL main_user with all privileges
mysql -uroot -p$MYSQL_ROOT_PASSWORD -e "CREATE USER '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';"
mysql -uroot -p$MYSQL_ROOT_PASSWORD -e "GRANT ALL PRIVILEGES ON *.* TO '$MYSQL_USER'@'%' WITH GRANT OPTION;"
mysql -uroot -p$MYSQL_ROOT_PASSWORD -e "FLUSH PRIVILEGES;"

# Print the content of the replication shared script
echo "printing the output of the replication script"
cat /shared/master_status.sql

# Wait for 5 seconds
sleep 5

# Print a message to indicate the start of the shared script execution
echo "Running shared script from setup-slave.sh"


# Connect to MySQL and execute SQL and Invoke the configured replication shared script
source /shared/master_status.sql

# Start the slave
echo "Starting the slave using: start slave"
mysql -uroot -p$MYSQL_ROOT_PASSWORD -e "START SLAVE;"

# Display slave status
echo "Display slave status:show slave status"
mysql -uroot -p$MYSQL_ROOT_PASSWORD -e "SHOW SLAVE STATUS\G;"