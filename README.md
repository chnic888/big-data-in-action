# Big Data Cluster

## Getting Started

### Prerequisites
- Ubuntu 22.04
- Ansible 2.10

## Setup Cluster

### Install multipass
```shell
sudo snap install multipass

snap install lxd

lxd init

multipass set local.driver=lxd

ssh-keygen -t rsa -b 4096 -N "" -f id_rsa
```

### Create Cluster
```shell
sudo nmcli connection add type bridge con-name localbr ifname localbr ipv4.method manual ipv4.addresses 10.13.31.1/24
 
bash sbin/create_cluster.sh <instance number>
```