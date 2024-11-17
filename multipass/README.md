# Setup Big Data Integration Environment

This project leverages `Multipass` to quickly set up an integrated big data learning environment, including Hadoop,
Hive, and Spark.

## Getting Started

Setup a local test cluster via Multipass

### Prerequisites

- Operating System: MacOS / Linux
- Dependencies：
    - Multipass
    - Ansible >= 2.10

## Installation

### Build Multiplass Cluster

Generate a default RSA key pair for passwordless SSH login to the generated VMs.

```shell
ssh-keygen -t rsa -b 4096 -N "" -f id_rsa
```

Run `build_cluster.sh` to build cluster.

```shell
cd multipass
./vm/build_cluster.sh 3 true
```

- `instance_number` indicates the number of nodes to create within the cluster
- `is_replace_source` indicates whether the default sources.list needs to be replaced by the third-part mirror source

### Install Hadoop Environment

Run `setup_hadoop.sh` script to setup Hadoop environment

```shell
./hadoop/setup_hadoop.sh
```

Use SSH to login vm01 and run start `start-all.sh`

```shell
ssh ubuntu@vm01
cd /opt/hadoop/sbin
./start-all.sh
```

Verify HDFS and YARN

- http://vm01:9870/dfshealth.html#tab-overview
- http://vm01:8088/cluster/nodes  

Submit m/r job to cluster

```shell
ssh ubuntu@vm01
hadoop jar /opt/hadoop/share/hadoop/mapreduce/hadoop-mapreduce-examples-3.4.0.jar pi 3 3
```