#!/bin/bash

if [ $# -ne 2 ]; then
    echo "Usage: $0 <instance number> <is replace source>"
    exit 1
fi

current_dir=$(dirname "$0")
node_count=$1
replace_source=$2

function pre_check {
    echo "Check OS and Arch..."

    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        OS="Linux"
        ARCH=$(uname -m)
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        OS="macOS"
        ARCH=$(uname -m)
    else
        echo "unknown OS and architecture..."
        exit 1
    fi

    echo "${OS}_${ARCH}"
}

function generate_source_list() {
    if [[ "$replace_source" == "false" ]]; then
        return 0
    fi

    if [[ "$ARCH" == "aarch64" ]] || [[ "$ARCH" == "arm64" ]]; then
        cp "${current_dir}/ansible/sources.list.aarch64" "${current_dir}/ansible/sources.list"
    else
        cp "${current_dir}/ansible/sources.list.amd64" "${current_dir}/ansible/sources.list"
    fi
}

function download_hadoop() {
    echo "download hadoop..."
    local url='https://mirrors.tuna.tsinghua.edu.cn/apache/hadoop/common/hadoop-3.4.0/'
    file_name='hadoop-3.4.0.tar.gz'

    if [[ "$ARCH" == "aarch64" ]] || [[ "$ARCH" == "arm64" ]]; then
      file_name='hadoop-3.4.0-aarch64.tar.gz'
    fi

    if [ ! -e "${current_dir}/hadoop/${file_name}" ]; then
      wget -P "${current_dir}/hadoop" "${url}${file_name}"
    else
      echo "${file_name} exist..."
    fi
}

function launch_cluster() {
    echo "launch multiplass cluster..."

    echo "copy id_rsa.pub..."
    cat ~/.ssh/id_rsa.pub > "$current_dir/1.tmp"

    for ((i = 1; i <= node_count; i++));
    do
        instance="vm$i"

        if [ ${#i} -eq 1 ]; then
          instance="vm0$i"
        fi

        if multipass list | grep -q $instance; then
          continue
        fi

        echo "launch VM instance $instance..."
        multipass launch jammy --name $instance -c 1 -m 2G -d 8G --mount "${current_dir}/hadoop/":/home/ubuntu

        echo "copy id_rsa.pub to $instance..."
        multipass transfer ./1.tmp $instance:/tmp/id_rsa.pub
        multipass exec $instance -- bash -c 'mkdir -p ~/.ssh && cat /tmp/id_rsa.pub >> ~/.ssh/authorized_keys && rm /tmp/id_rsa.pub'

        ip=$(multipass exec $instance -- bash -c "hostname -I | cut -d ' ' -f 1")
        echo "Write IP ${ip} to inventory file..."
        echo "[vm]" > "$current_dir/ansible/inventory"
        echo "${ip}" >> "$current_dir/ansible/inventory"

        echo "launch VM instance $instance successfully..."
    done

    rm "$current_dir/1.tmp"
}

function install_dependency() {
    ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i ./ansible/inventory ./ansible/vm_update_upgrade.yaml --extra-vars "{'replace_source': $replace_source}"
}

pre_check
generate_source_list
download_hadoop
launch_cluster
install_dependency
