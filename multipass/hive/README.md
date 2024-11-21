# Install Hive

## Setup Hive Metastore Server

### Install Metastore Database

#### Install Mysql Server 8.0

```shell
ssh ubuntu@vm00
sudo apt install mysql-server-8.0 -y
```

#### Update my.cnf

Add the following config to `/etc/mysql/my.cnf`

```ini
[mysqld]
bind-address = 0.0.0.0
```

Restart mysql service

```shell
sudo systemctl restart mysql.service
```

#### Run Mysql Secure Script

Run `mysql_secure_installation` to make some basic security configuration

```shell
sudo mysql_secure_installation
```

#### Create New User for Hive

Login the database

```shell
sudo mysql
```

Create new user for hive metastore

```
CREATE USER 'hive'@'%' IDENTIFIED BY 'hive';

GRANT ALL PRIVILEGES ON *.* TO 'hive'@'%' WITH GRANT OPTION;

FLUSH PRIVILEGES;
```

### Install Metastore Server

Run `setup_hive.sh` to setup hive metastore standalone environment

```shell
./hive/setup_hive_metastore.sh
```

Start metastore service

```shell
nohup /opt/hive-metastore/bin/start-metastore > /opt/hive-metastore/logs/metastore.out 2>&1 &
```

## Setup Hive on Hadoop Cluster