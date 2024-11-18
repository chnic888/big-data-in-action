#!/bin/bash

HADOOP_VERSION="hadoop-3.4.0"
hadoop_vm=""

function generate_hadoop_host_group() {
    if grep -q '^\[hadoop\]' ./inventory; then
        return
    fi

    echo "Generate hadoop host group..."
    echo "" >> ./inventory
    echo "[hadoop]" >> ./inventory

    while read -r line; do
        echo "$line" >> ./inventory
        hostname=$(echo "$line" | awk '{print $1}')
        hadoop_vm="${hadoop_vm},${hostname}"
    done < <(grep '^vm' "./inventory" | grep -v '^vm00')

    hadoop_vm=${hadoop_vm#,}
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
    local url="https://mirrors.tuna.tsinghua.edu.cn/apache/hadoop/common/${HADOOP_VERSION}/"
    file_name="${HADOOP_VERSION}.tar.gz"

    if [[ "$ARCH" == "aarch64" ]] || [[ "$ARCH" == "arm64" ]]; then
        file_name="${HADOOP_VERSION}-aarch64.tar.gz"
    fi

    if [ ! -e "./hadoop/archive/${file_name}" ]; then
        echo "${file_name} not found, start to download file..."
        wget -P "./hadoop/archive" "${url}${file_name}"
    else
        echo "File ${file_name} exist..."
    fi

    if [ ! -e "./hadoop/archive/${HADOOP_VERSION}" ]; then
        echo "Extract ${file_name}..."
        tar xf "./hadoop/archive/${file_name}" -C ./hadoop/archive/
    fi
}

function mount_hadoop() {
    IFS=',' read -ra hadoop_vm_array <<< "$hadoop_vm"
    for vm in "${hadoop_vm_array[@]}"; do
        echo "Mount ./hadoop/archive/${HADOOP_VERSION} to ${vm}:/home/ubuntu/hadoop"
        multipass mount "./hadoop/archive/${HADOOP_VERSION}" "${vm}":/home/ubuntu/hadoop
    done
}

function install_hadoop() {
    ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i inventory ./hadoop/install_hadoop.yaml
}

function init_master() {
    ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i inventory ./hadoop/init_master.yaml
}

generate_hadoop_host_group
pre_check
download_hadoop
mount_hadoop
install_hadoop
init_master