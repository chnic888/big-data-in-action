#!/bin/bash

FLINK_VERSION="1.20.2"

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

function mount_flink() {
    for host in $(ansible-inventory -i inventory --list | jq -r '.hadoop.hosts[]'); do
        echo "Mount ./flink/archive/flink-${FLINK_VERSION} on $host:/home/ubuntu/flink"
        multipass mount "./flink/archive/flink-${FLINK_VERSION}" "$host":/home/ubuntu/flink
    done
}

function unmount_flink() {
    for host in $(ansible-inventory -i inventory --list | jq -r '.hadoop.hosts[]'); do
        echo "Unmount $host:/home/ubuntu/flink..."
        multipass unmount "$host":/home/ubuntu/flink
    done
}

download_flink
mount_flink
unmount_flink