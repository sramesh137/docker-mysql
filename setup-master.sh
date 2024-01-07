#!/bin/bash
# Inside setup-master.sh
echo "Setting up master..."

# Create main_db database
mysql -u root -p$MYSQL_ROOT_PASSWORD -e "CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE;"

# Update replication user password with the mysql_native_password
mysql  -uroot -p$MYSQL_ROOT_PASSWORD -e "DROP USER '$MYSQL_REPL_USER'@'%';"
mysql  -uroot -p$MYSQL_ROOT_PASSWORD -e "CREATE USER '$MYSQL_REPL_USER'@'%' IDENTIFIED WITH mysql_native_password BY '$MYSQL_REPL_PASSWORD';"

# Grant privileges
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
echo "mysql -uroot -p$MYSQL_ROOT_PASSWORD -e \"CHANGE MASTER TO MASTER_HOST='master', MASTER_PORT=3306, MASTER_USER='repl_user', MASTER_PASSWORD='repl_pass', MASTER_LOG_FILE='$CURRENT_LOG_FILE', MASTER_LOG_POS=$CURRENT_LOG_POS;\"" | tee /shared/master_status.sql
echo "permission changed to chmod +r"
chmod +r /shared/master_status.sql

#Test data
mysql -uroot -p$MYSQL_ROOT_PASSWORD -e "USE $MYSQL_DATABASE; CREATE TABLE t1(c1 TEXT); INSERT INTO t1(c1) VALUES ('Test data');"
