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

1. Generate a default RSA key pair for passwordless SSH login to the generated VMs.

```shell
ssh-keygen -t rsa -b 4096 -N "" -f id_rsa
```

2. Run `build_cluster.sh` script to build cluster.

```shell
cd multipass

./vm/build_cluster.sh 3 true
```

- `instance_number` indicates the number of nodes to create within the cluster
- `is_replace_source` indicates whether the default sources.list needs to be replaced by the third-part mirror source

### Install Hadoop Environment

1. Run `setup_hadoop.sh` script to setup hadoop enviroment

```shell
./hadoop/setup_hadoop.sh
```

2. Start hadoop cluster

```shell
multipass exec vm01 -- bash -c '/opt/hadoop/sbin/start-all.sh'
```

- `vm01` the cluster uses vm01 as the master by default

3. Verify environment

- http://10.242.171.21:9870  
- http://10.242.171.21:8088  