#!/bin/bash

HIVE_VERSION=4.0.1

function mount_hive() {
    for host in $(ansible-inventory -i inventory --list | jq -r '.hadoop.hosts[]'); do
        echo "Mount ./hive/archive/apache-hive-${HIVE_VERSION}-bin to $host"
        multipass mount "./hive/archive/apache-hive-${HIVE_VERSION}-bin" "$host":/home/ubuntu/hive
    done
}

function transfer_jdbc_driver() {
    for host in $(ansible-inventory -i inventory --list | jq -r '.hadoop.hosts[]'); do
        multipass transfer "./hive/lib/mysql-connector-j-9.1.0.jar" "$host":/home/ubuntu
    done
}

function install_hive() {
    ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i inventory ./hive/install_hive.yaml
}

function unmount_hive() {
    for host in $(ansible-inventory -i inventory --list | jq -r '.hadoop.hosts[]'); do
        echo "Unmount $host:/home/ubuntu/hive..."
        multipass unmount "$host":/home/ubuntu/hive
    done

}

mount_hive
transfer_jdbc_driver
install_hive
unmount_hive