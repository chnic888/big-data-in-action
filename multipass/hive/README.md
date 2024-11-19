# Install Hive

## Setup Mysql Database

### Install Mysql Server 8.0

```shell
ssh ubuntu@vm00
sudo apt install mysql-server-8.0 -y
```

### Update my.cnf

Add the following config to `/etc/mysql/my.cnf`

```ini
[mysqld]
bind-address = 0.0.0.0
```

Restart mysql service

```shell
sudo systemctl restart mysql.service
```

### Run `mysql_secure_installation`

Run `mysql_secure_installation` to make some basic security configuration

```shell
sudo mysql_secure_installation
```

### Create New User for Hive

Login the database

```shell
sudo mysql
```

Create new user for hive metastore

```sql
CREATE USER 'hive'@'%' IDENTIFIED BY 'hive';

GRANT ALL PRIVILEGES ON *.* TO 'hive'@'%' WITH GRANT OPTION;

FLUSH PRIVILEGES;
```