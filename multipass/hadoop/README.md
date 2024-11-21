# Install Hadoop

## Setup Hadoop Environment

Run `setup_hadoop.sh` script to setup Hadoop environment

```shell
./hadoop/setup_hadoop.sh
```

## Start Hadoop Service

Enter the shell of the `vm01` instance and then execute `start-all.sh` to start HDFS and YARN services.

```shell
ssh ubuntu@vm01

/opt/hadoop/sbin/start-all.sh
```

## Verify HDFS and YARN Services

- Access http://vm01:9870/dfshealth.html#tab-overview to check tha availability of HDFS
- Access http://vm01:8088/cluster/nodes to check tha availability of YARN

## Submit m/r Job to Cluster

The m/r job cloud be submitted on both cluster and local machine

```shell
ssh ubuntu@vm01
hadoop jar /opt/hadoop/share/hadoop/mapreduce/hadoop-mapreduce-examples-3.4.0.jar pi 3 3
```