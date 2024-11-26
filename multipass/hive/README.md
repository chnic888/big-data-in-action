# Install Apache Hive

## Setup Hive Metastore Server

```shell
./hive/setup_metastore.sh

beeline -u jdbc:hive2://vm01:10000 -n ubuntu
```

Start metastore service

```shell
nohup /opt/hive/bin/hive --service metastore > /opt/hive/logs/metastore.log 2>&1 &
```

## Setup Hive on Hadoop Cluster

```shell
./hive/setup_hive.sh

nohup /opt/hive/bin/hiveserver2 > /opt/hive/logs/hiveserver2.log 2>&1 &
```