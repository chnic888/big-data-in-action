# Cluster Setup via Multipass

## Getting Started

Setup a local test cluster via Multipass

### Prerequisites

- Ubuntu 22.04
- Ansible 2.10+

## Install multipass

Linux

```shell
sudo snap install multipass
```

MacOS

```shell
brew install --cask multipass
```

## Create Cluster

Generate a default RSA key pair for passwordless SSH login to the generated VMs.

```shell
ssh-keygen -t rsa -b 4096 -N "" -f id_rsa
```

Then execute the `build_cluster.sh` script to create the VM cluster.

`instance_number` indicates the number of nodes to create within the cluster 
`is_replace_source` indicates whether the default sources.list needs to be replaced by the third-part mirror source

```shell
cd multipass

./vm/build_cluster.sh 3 true
```

## Install Hadoop Environment

```shell
./hadoop/setup_hadoop.sh
```

### Start HDFS cluster

```shell
multipass exec vm01 -- bash -c '/opt/hadoop/sbin/start-all.sh'
```