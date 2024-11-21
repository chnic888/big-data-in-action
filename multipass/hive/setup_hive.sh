#!/bin/bash

HIVE_VERSION="hive-4.0.1"
HIVE_STANDALONE_METASTORE="hive-standalone-metastore-3.0.0"
HIVE_METASTORE="hive-metastore-3.0.0"

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
    local base_url="https://mirrors.tuna.tsinghua.edu.cn/apache/hive"
    hive_file_name="apache-${HIVE_VERSION}-bin.tar.gz"
    hive_standalone_metastore_file_name="${HIVE_STANDALONE_METASTORE}-bin.tar.gz"

    if [ ! -e "./hive/archive/${hive_file_name}" ]; then
        echo "${hive_file_name} not found, start to download file..."
        wget -P "./hive/archive" "${base_url}/${HIVE_VERSION}/${hive_file_name}"
    else
        echo "File ${hive_file_name} exist..."
    fi

    if [ ! -e "./hive/archive/apache-${HIVE_VERSION}-bin" ]; then
        echo "Extract ${hive_file_name}..."
        tar xf "./hive/archive/${hive_file_name}" -C ./hive/archive/
    fi

    if [ ! -e "./hive/archive/${hive_standalone_metastore_file_name}" ]; then
        echo "${hive_standalone_metastore_file_name} not found, start to download file..."
        wget -P "./hive/archive" "${base_url}/${HIVE_STANDALONE_METASTORE}/${hive_standalone_metastore_file_name}"
    else
        echo "File ${hive_file_name} exist..."
    fi

    if [ ! -e "./hive/archive/apache-${HIVE_METASTORE}-bin" ]; then
        echo "Extract ${hive_standalone_metastore_file_name}..."
        tar xf "./hive/archive/${hive_standalone_metastore_file_name}" -C ./hive/archive/
    fi
}

function mount_standalone_metastore() {
    echo "Mount ./hive/archive/apache-${HIVE_VERSION}-bin" vm00:/home/ubuntu/hive
    multipass mount "./hive/archive/apache-${HIVE_METASTORE}-bin" vm00:/home/ubuntu/hive-metastore
}

function transfer_jdbc_driver() {
    multipass transfer "./hive/archive/mysql-connector-j-9.1.0.jar" vm00:/home/ubuntu
}

function install_metastore() {
    ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i inventory ./hive/install_metastore.yaml
}

generate_metastore_host_group
download_hive
transfer_jdbc_driver
mount_standalone_metastore
install_metastore
