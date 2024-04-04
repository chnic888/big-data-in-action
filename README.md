# Big Data Cluster

## Getting Started

### Prerequisites
- Python 3.10

## Setup Cluster

### Install multipass

#### Ubuntu(22.04)
```shell
sudo snap install multipass

snap install lxd

lxd init

multipass set local.driver=lxd
```

#### MacOS
```shell
brew install --cask multipass

multipass set local.driver=qemu
```

### Create Cluster
```shell
sudo nmcli connection add type bridge con-name localbr ifname localbr ipv4.method manual ipv4.addresses 10.13.31.1/24

bash sbin/create_cluster.sh <instance number>
```