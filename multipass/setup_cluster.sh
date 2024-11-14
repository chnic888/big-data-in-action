#!/bin/bash

HADOOP_VERSION="hadoop-3.4.0"

if [ $# -ne 2 ]; then
    echo "Usage: $0 <instance number> <is replace source>"
    exit 1
fi

node_count=$1
replace_source=$2

function clean_up() {
    rm -f "./ansible/inventory"
    rm -f "./ansible/sources.list"
}

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

function generate_source_list() {
    if [[ "$replace_source" == "false" ]]; then
        echo "Skip generate sources.list and will use default config..."
        return 0
    fi

    if [[ "$ARCH" == "aarch64" ]] || [[ "$ARCH" == "arm64" ]]; then
        cp "./ansible/sources.list.aarch64" "./ansible/sources.list"
    else
        cp "./ansible/sources.list.amd64" "./ansible/sources.list"
    fi
}

function download_hadoop() {
    local url="https://mirrors.tuna.tsinghua.edu.cn/apache/hadoop/common/${HADOOP_VERSION}/"
    file_name="${HADOOP_VERSION}.tar.gz"

    if [[ "$ARCH" == "aarch64" ]] || [[ "$ARCH" == "arm64" ]]; then
      file_name="${HADOOP_VERSION}-aarch64.tar.gz"
    fi

    if [ ! -e "./hadoop/${file_name}" ]; then
      echo "${file_name} not found, start to download file..."
      wget -P "./hadoop" "${url}${file_name}"
    else
      echo "File ${file_name} exist..."
    fi

    if [ ! -e "./hadoop/${HADOOP_VERSION}" ]; then
      echo "extract ${file_name}..."
      tar xf "./hadoop/${file_name}" -C ./hadoop
    fi
}

function launch_cluster() {
    echo "Start to launch cluster..."
    cat ~/.ssh/id_rsa.pub > "./1.tmp"

    for ((i = 1; i <= node_count; i++));
    do
        instance="vm$i"

        if [ ${#i} -eq 1 ]; then
          instance="vm0$i"
        fi

        if multipass list | grep -q $instance; then
          continue
        fi

        echo "Launch VM instance ${instance}..."
        multipass launch jammy --name $instance -c 1 -m 2G -d 8G
        multipass mount "./hadoop/${HADOOP_VERSION}" $instance:/home/ubuntu/hadoop

        echo "Copy id_rsa.pub to ${instance}..."
        multipass transfer ./1.tmp $instance:/tmp/id_rsa.pub
        multipass exec $instance -- bash -c 'mkdir -p ~/.ssh && cat /tmp/id_rsa.pub >> ~/.ssh/authorized_keys && rm /tmp/id_rsa.pub'

        ip=$(multipass exec $instance -- bash -c "hostname -I | cut -d ' ' -f 1")
        echo "Write IP ${ip} to inventory file..."
        echo "[vm]" > "./ansible/inventory"
        echo "${ip}" >> "./ansible/inventory"

        echo "Launch VM instance ${instance} successfully..."
    done

    rm "./1.tmp"
}

function install_dependency() {
    ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i ./ansible/inventory ./ansible/vm_update_upgrade.yaml --extra-vars "{'replace_source': $replace_source}"
}

clean_up
pre_check
generate_source_list
download_hadoop
launch_cluster
install_dependency
