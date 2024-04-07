# Big Data Platform

## Getting Started

The big data platform built on Multipass and Ambari.

### Prerequisites

- Ubuntu 22.04 AMD64
- Ansible 2.10
- Ambari 2.7.8

## Setup Cluster via Multipass

### Install multipass

Install multipass and its backend implementation lxd. Initialize lxd and set the multipass local driver to it.

```shell
sudo snap install multipass

snap install lxd

lxd init

multipass set local.driver=lxd
```

### Create Cluster

Generate a default RSA key pair for passwordless SSH login to the generated VMs and create a local bridge
named `localbr` to configure virtual static IPs. Then execute the `create_cluster.sh` script to create the VM cluster.

```shell
ssh-keygen -t rsa -b 4096 -N "" -f id_rsa

sudo nmcli connection add type bridge con-name localbr ifname localbr ipv4.method manual ipv4.addresses 10.13.31.1/24
 
bash sbin/create_cluster.sh <instance number>
```

### Update Cluster

Please ensure that all VMs within the cluster can be accessed via SSH from the host machine and then execute the ansible
playbook to upgrade the VMs。

```shell
ansible-playbook -i sbin/inventory sbin/vm_update_upgrade.yaml
```                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         