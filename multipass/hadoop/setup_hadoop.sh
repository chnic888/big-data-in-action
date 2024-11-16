#!/bin/bash

HADOOP_VERSION="hadoop-3.4.0"

function pre_check {
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
    local url="https://mirrors.tuna.tsinghua.edu.cn/apache/hadoop/common/${HADOOP_VERSION}/"
    file_name="${HADOOP_VERSION}.tar.gz"

    if [[ "$ARCH" == "aarch64" ]] || [[ "$ARCH" == "arm64" ]]; then
        file_name="${HADOOP_VERSION}-aarch64.tar.gz"
    fi

    if [ ! -e "./hadoop/archive/${file_name}" ]; then
        echo "${file_name} not found, start to download file..."
        wget -P "./hadoop" "${url}${file_name}"
    else
        echo "File ${file_name} exist..."
    fi

    if [ ! -e "./hadoop/archive/${HADOOP_VERSION}" ]; then
        echo "Extract ${file_name}..."
        tar xf "./hadoop/archive/${file_name}" -C ./hadoop/archive/
    fi
}

function mount_hadoop() {
    grep '^vm[0-9]\{2\}' < ./inventory | while IFS= read -r line
    do
        vm_name=$(echo "$line" | awk '{print $1}')
        echo "Mount ./hadoop/archive/${HADOOP_VERSION} to ${vm_name}:/home/ubuntu/hadoop"
        multipass mount "./hadoop/archive/${HADOOP_VERSION}" "$vm_name":/home/ubuntu/hadoop
    done

}

function install_hadoop() {
    ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i inventory ./hadoop/install_hadoop.yaml
}

function init_master() {
    ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i inventory ./hadoop/init_master.yaml
}

pre_check
download_hadoop
mount_hadoop
install_hadoop
init_master