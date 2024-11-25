#!/bin/bash

HADOOP_VERSION="3.4.0"
ANSIBLE_GROUP="hadoop"

function generate_hadoop_host_group() {
    if grep -q "^\[$ANSIBLE_GROUP\]" ./inventory; then
        return
    fi

    echo "Generate $ANSIBLE_GROUP host group..."
    echo "" >> ./inventory
    echo "[$ANSIBLE_GROUP]" >> ./inventory

    while read -r line; do
        echo "$line" >> ./inventory
    done < <(grep '^vm' "./inventory" | grep -v '^vm00')
}

function pre_check() {
    echo "Check OS and Arch..."

    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        OS="Linux"
        ARCH=$(uname -m)
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        OS="macOS"
        ARCH=$(uname -m)
    else
        echo "Unknown OS and architecture..."
        exit 1
    fi

    echo "${OS}_${ARCH}"
}

function download_hadoop() {
    local url="https://mirrors.tuna.tsinghua.edu.cn/apache/hadoop/common/hadoop-$HADOOP_VERSION/"
    file_name="hadoop-$HADOOP_VERSION.tar.gz"

    if [[ "$ARCH" == "aarch64" ]] || [[ "$ARCH" == "arm64" ]]; then
        file_name="hadoop-$HADOOP_VERSION-aarch64.tar.gz"
    fi

    if [ ! -e "./hadoop/archive/$file_name" ]; then
        echo "$file_name not found, start to download file..."
        wget -P "./hadoop/archive" "${url}${file_name}"
    else
        echo "File $file_name exist..."
    fi

    if [ ! -e "./hadoop/archive/hadoop-$HADOOP_VERSION" ]; then
        echo "Extract ${file_name}..."
        tar xf "./hadoop/archive/$file_name" -C ./hadoop/archive/
    fi
}

function mount_hadoop() {
    if grep -q '^vm00' ./inventory; then
        ANSIBLE_GROUP="vm"
    fi

    for host in $(ansible-inventory -i inventory --list | jq -r ".$ANSIBLE_GROUP.hosts[]"); do
        echo "Mount ./hadoop/archive/hadoop-${HADOOP_VERSION} to ${host}:/home/ubuntu/hadoop..."
        multipass mount "./hadoop/archive/hadoop-${HADOOP_VERSION}" "${host}":/home/ubuntu/hadoop
    done
}

function install_hadoop() {
    ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i inventory ./hadoop/install_hadoop.yaml --extra-vars "{'target_host': $ANSIBLE_GROUP}"
}

function init_master() {
    ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i inventory ./hadoop/init_master.yaml
}

function unmount_hadoop() {
    for host in $(ansible-inventory -i inventory --list | jq -r ".$ANSIBLE_GROUP.hosts[]"); do
        echo "Unmount ${host}:/home/ubuntu/hadoop..."
        multipass unmount "${host}":/home/ubuntu/hadoop
    done
}

generate_hadoop_host_group
pre_check
download_hadoop
mount_hadoop
install_hadoop
init_master
unmount_hadoop