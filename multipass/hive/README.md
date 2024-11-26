# Install Apache Hive

## Setup Hive Metastore Server

Run `setup_metastore.sh` script to setup Hive metastore server

```shell
./hive/setup_metastore.sh
```

Enter the shell of the `vm00` instance and start metastore service

```shell
ssh ubuntu@vm00

nohup /opt/hive/bin/hive --service metastore > /opt/hive/logs/metastore.log 2>&1 &
```

## Setup Hive on Hadoop Cluster

Run `setup_hive.sh` script to setup Hive service

```shell
./hive/setup_hive.sh
```

Enter the shell of the `vm01` instance and start metastore service

```shell
ssh ubuntu@vm01

nohup /opt/hive/bin/hiveserver2 > /opt/hive/logs/hiveserver2.log 2>&1 &
```

## Validate Hive

Verify HiveServer2 service

- Access http://vm01:10002/ to check tha availability of HiveServer2

Enter the shell of the `vm01` instance and login HiveServer2 

```shell
ssh ubuntu@vm01

/opt/hive/bin/beeline -u jdbc:hive2://vm01:10000 -n ubuntu
```

Create test data to verify Hive on Hadoop cluster
```sql
CREATE TABLE test_table (id INT, name STRING);
INSERT INTO test_table VALUES (1, 'Alice'), (2, 'Bob');
SELECT * FROM test_table;
```