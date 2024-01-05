# docker-mysql
Using docker-compose.yaml creating replication for mysql master - slave1 & slave2

```

project/
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

Explanation:
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


