#!/bin/bash

HIVE_STANDALONE_METASTORE_VERSION="3.0.0"
HIVE_VERSION="4.0.1"

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
    local base_url="https://archive.apache.org/dist/hive/hive-$HIVE_VERSION"
    hive_file_name="apache-hive-${HIVE_VERSION}-bin.tar.gz"

    if [ ! -e "./hive/archive/${hive_file_name}" ]; then
        echo "${hive_file_name} not found, start to download file..."
        wget -P "./hive/archive" "${base_url}/${hive_file_name}"
    else
        echo "File ${hive_file_name} exist..."
    fi

    if [ ! -e "./hive/archive/apache-hive-${HIVE_VERSION}-bin" ]; then
        echo "Extract ${hive_file_name}..."
        tar xf "./hive/archive/${hive_file_name}" -C ./hive/archive/
    fi
}

function download_hive_metastore() {
    local base_url="https://mirrors.tuna.tsinghua.edu.cn/apache/hive"
    hive_standalone_metastore_file_name="hive-standalone-metastore-$HIVE_STANDALONE_METASTORE_VERSION-bin.tar.gz"

    if [ ! -e "./hive/archive/${hive_standalone_metastore_file_name}" ]; then
        echo "${hive_standalone_metastore_file_name} not found, start to download file..."
        wget -P "./hive/archive" "${base_url}/hive-standalone-metastore-$HIVE_STANDALONE_METASTORE_VERSION/${hive_standalone_metastore_file_name}"
    else
        echo "File ${hive_standalone_metastore_file_name} exist..."
    fi

    if [ ! -e "./hive/archive/apache-hive-metastore-$HIVE_STANDALONE_METASTORE_VERSION-bin" ]; then
        echo "Extract ${hive_standalone_metastore_file_name}..."
        tar xf "./hive/archive/${hive_standalone_metastore_file_name}" -C ./hive/archive/
    fi
}

function mount_hive() {
    echo "Mount ./hive/archive/apache-hive-$HIVE_VERSION-bin"
    multipass mount "./hive/archive/apache-hive-$HIVE_VERSION-bin" vm00:/home/ubuntu/hive
}

function mount_standalone_metastore() {
    echo "Mount ./hive/archive/apache-hive-metastore-$HIVE_STANDALONE_METASTORE_VERSION-bin"
    multipass mount "./hive/archive/apache-hive-metastore-$HIVE_STANDALONE_METASTORE_VERSION-bin" vm00:/home/ubuntu/hive-metastore
}

function transfer_jdbc_driver() {
    multipass transfer "./hive/lib/mysql-connector-j-9.1.0.jar" vm00:/home/ubuntu
}

function install_metastore() {
    ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i inventory ./hive/install_metastore.yaml
}

generate_metastore_host_group
download_hive
download_hive_metastore
transfer_jdbc_driver
mount_hive
mount_standalone_metastore
install_metastore
