# MySQL Replication Docker Project

## Overview

This project sets up a MySQL replication environment using Docker Compose. It includes a master MySQL server and two slave MySQL servers. The replication is configured and managed through Docker Compose files, scripts, and configuration files.

## Features

- MySQL master and slave setup in Docker containers
- Automated configuration of replication parameters
- Separate environment files for master and slave configurations
- Docker Compose orchestration for easy deployment

## Project Directory Tree Map Structure
```
docker-mysql-project/
|-- config/
|   |-- master_config.cnf
|   |-- slave_config.cnf
|-- env/
|   |-- master.env
|   |-- slave.env
|-- data/
|   |-- master/
|   |-- slave1/
|   |-- slave2/
|-- docker-compose.yaml
|-- setup-master.sh
|-- setup-slave.sh
```

## Tree Map Explanation:

* config/: Directory containing MySQL configuration files.
    * master_config.cnf: Configuration file for the MySQL master.
    * slave_config.cnf: Configuration file for MySQL slaves.
* env/: Directory containing environment files.
    * master.env: Environment variables for the MySQL master.
    * slave.env: Environment variables for MySQL slaves.
* data/: Directory for storing MySQL data.
    * master/: Directory for the master MySQL container's data.
    * slave1/: Directory for the first slave MySQL container's data.
    * slave2/: Directory for the second slave MySQL container's data.
* docker-compose.yaml: Docker Compose file for defining services, networks, and volumes.
* setup-master.sh: Replication setup script for the MySQL master.
* setup-slave.sh: Replication setup script for MySQL slaves.

## Usage

Clone the repository:
   ```bash
   git clone https://github.com/sramesh137/docker-mysql.git
   cd docker-mysql
   ```

1. Customize environment files:

   - Update env/master.env with master configuration.
   - Update env/slave.env with slave configurations.

2. Start the MySQL replication environment:
   ```
   docker-compose up -d
   ```

3. Check the status and logs:
   ```
   docker-compose ps
   docker-compose logs
   ```

4. Access MySQL containers:
   - Master
   ```
   docker exec -it master mysql -uroot -p
   ```
   - Slaves
   ```
   docker exec -it slave1 mysql -uroot -p
   docker exec -it slave2 mysql -uroot -p
   ```
5. Monitor replication status:

   ```
   docker exec -it slave1 mysql -uroot -p -e "SHOW SLAVE STATUS\G"
   docker exec -it slave2 mysql -uroot -p -e "SHOW SLAVE STATUS\G"
   ```

### Troubleshooting
- If you encounter issues during setup or replication, check the logs and error messages in the respective containers.
- Review the MySQL documentation for replication troubleshooting: [MySQL Replication Troubleshooting](https://dev.mysql.com/doc/mysql-replication-excerpt/8.0/en/replication-features-errors.html)

### Contributing
Feel free to contribute to this project by opening issues or pull requests.
