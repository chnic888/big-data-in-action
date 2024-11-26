#!/bin/bash

HIVE_VERSION="4.0.1"
HIVE_DB_PASSWORD="Xy7@dFqP1zW"

function generate_metastore_host_group() {
    if grep -q '^\[metastore\]' ./inventory; then
        return
    fi

    echo "Generate metastore host group..."
    echo "" >> ./inventory
    echo "[metastore]" >> ./inventory

    vm00_line=$(grep '^vm00' ./inventory | head -n 1)
    if [[ -n "$vm00_line" ]]; then
        echo "$vm00_line" >> ./inventory
    fi
}

function download_hive() {
    local hive_base_url="https://mirrors.tuna.tsinghua.edu.cn/apache/hive/hive-$HIVE_VERSION"
    hive_file_name="apache-hive-${HIVE_VERSION}-bin.tar.gz"

    if [ ! -e "./hive/archive/${hive_file_name}" ]; then
        echo "${hive_file_name} not found, start to download file..."
        wget -P "./hive/archive" "${hive_base_url}/${hive_file_name}"
    else
        echo "File ${hive_file_name} exist..."
    fi

    if [ ! -e "./hive/archive/apache-hive-${HIVE_VERSION}-bin" ]; then
        echo "Extract ${hive_file_name}..."
        tar xf "./hive/archive/${hive_file_name}" -C ./hive/archive/
    fi
}

function install_db() {
    ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i inventory ./hive/install_db.yaml --extra-vars "{'hive_password': $HIVE_DB_PASSWORD}"
}

function transfer_jdbc_driver() {
    multipass transfer "./hive/lib/mysql-connector-j-9.1.0.jar" vm00:/home/ubuntu
}

function mount_hive() {
    echo "Mount ./hive/archive/apache-hive-$HIVE_VERSION-bin..."
    multipass mount "./hive/archive/apache-hive-$HIVE_VERSION-bin" vm00:/home/ubuntu/hive
}

function install_metastore() {
    ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i inventory ./hive/install_metastore.yaml --extra-vars "{'hive_password': $HIVE_DB_PASSWORD}"
}

function unmount_hive() {
    echo "Unmount vm00:/home/ubuntu/hive..."
    multipass unmount vm00:/home/ubuntu/hive
}

generate_metastore_host_group
download_hive
install_db
transfer_jdbc_driver
mount_hive
install_metastore
unmount_hive
