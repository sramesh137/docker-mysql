#!/bin/bash

# Create main_db database
mysql -u root -p$MYSQL_ROOT_PASSWORD -e "CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE;"

# Create replication user and grant privileges
mysql -u root -p$MYSQL_ROOT_PASSWORD -e "CREATE USER IF NOT EXISTS '$MYSQL_REPL_USER'@'%' IDENTIFIED BY '$MYSQL_REPL_PASSWORD';"
mysql -u root -p$MYSQL_ROOT_PASSWORD -e "GRANT REPLICATION SLAVE ON *.* TO '$MYSQL_REPL_USER'@'%';"
mysql -u root -p$MYSQL_ROOT_PASSWORD -e "FLUSH PRIVILEGES;"

# Get master status
MASTER_STATUS=$(mysql -u root -p$MYSQL_ROOT_PASSWORD -e "SHOW MASTER STATUS;" --skip-column-names)
CURRENT_LOG_FILE=$(echo "$MASTER_STATUS" | awk '{print $1}')
CURRENT_LOG_POS=$(echo "$MASTER_STATUS" | awk '{print $2}')

# Output master status for slave configuration
echo "Current Binary Log File: $CURRENT_LOG_FILE"
echo "Current Binary Log Position: $CURRENT_LOG_POS"

# Save master status to a file for later use in slave configuration
echo "CHANGE MASTER TO MASTER_HOST='master', MASTER_PORT=3306, MASTER_USER='$MYSQL_REPL_USER', MASTER_PASSWORD='$MYSQL_REPL_PASSWORD', MASTER_LOG_FILE='$CURRENT_LOG_FILE', MASTER_LOG_POS=$CURRENT_LOG_POS;" > master_status.sql