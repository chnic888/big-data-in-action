#!/bin/bash

FLINK_VERSION="1.20.2"

flink_shaded_hadoop_file_name="flink-shaded-hadoop-2-uber-2.8.3-10.0.jar"
commons_cli_file_name="commons-cli-1.5.0.jar"

function download_flink() {
    local flink_base_url="https://dlcdn.apache.org/flink/flink-$FLINK_VERSION"
    flink_file_name="flink-$FLINK_VERSION-bin-scala_2.12.tgz"

    if [ ! -e "./flink/archive/${flink_file_name}" ]; then
        echo "${flink_file_name} not found, start to download file..."
        wget -P "./flink/archive" "${flink_base_url}/${flink_file_name}"
    else
        echo "File ${flink_file_name} exist..."
    fi

    if [ ! -e "./flink/archive/flink-${FLINK_VERSION}" ]; then
        echo "Extract ${flink_file_name}..."
        tar xf "./flink/archive/${flink_file_name}" -C ./flink/archive/
    fi
}

function download_flink_shaded_hadoop() {
    if [ ! -e "./flink/archive/${flink_shaded_hadoop_file_name}" ]; then
        echo "${flink_shaded_hadoop_file_name} not found, start to download file..."
        wget -P "./flink/archive" "https://repo.maven.apache.org/maven2/org/apache/flink/flink-shaded-hadoop-2-uber/2.8.3-10.0/${flink_shaded_hadoop_file_name}"
    else
        echo "File ${flink_shaded_hadoop_file_name} exist..."
    fi

    if [ ! -e "./flink/archive/${commons_cli_file_name}" ]; then
        echo "${commons_cli_file_name} not found, start to download file..."
        wget -P "./flink/archive" "https://repo1.maven.org/maven2/commons-cli/commons-cli/1.5.0/${commons_cli_file_name}"
    else
        echo "File ${commons_cli_file_name} exist..."
    fi
}

function mount_flink() {
    for host in $(ansible-inventory -i inventory --list | jq -r '.hadoop.hosts[]'); do
        echo "Mount ./flink/archive/flink-${FLINK_VERSION} on $host:/home/ubuntu/flink"
        multipass mount "./flink/archive/flink-${FLINK_VERSION}" "$host":/home/ubuntu/flink
    done
}

function transfer_hadoop_jars() {
    for host in $(ansible-inventory -i inventory --list | jq -r '.hadoop.hosts[]'); do
        echo "Transfer ./flink/archive/${flink_shaded_hadoop_file_name} on $host:/home/ubuntu/"
        multipass transfer "./flink/archive/${flink_shaded_hadoop_file_name}" "$host":/home/ubuntu/

        echo "Transfer ./flink/archive/${commons_cli_file_name} on $host:/home/ubuntu/"
        multipass transfer "./flink/archive/${commons_cli_file_name}" "$host":/home/ubuntu/
    done    
}

function install_flink() {
    ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i inventory ./flink/install_flink.yaml
}

function unmount_flink() {
    for host in $(ansible-inventory -i inventory --list | jq -r '.hadoop.hosts[]'); do
        echo "Unmount $host:/home/ubuntu/flink..."
        multipass unmount "$host":/home/ubuntu/flink
    done
}

download_flink
download_flink_shaded_hadoop
mount_flink
transfer_hadoop_jars
install_flink
unmount_flink