#!/bin/bash

SPARK_VERSION=3.5.3

function download_spark() {
    local spark_base_url="https://mirrors.tuna.tsinghua.edu.cn/apache/spark/spark-$SPARK_VERSION"
    spark_file_name="spark-$SPARK_VERSION-bin-hadoop3.tgz"

    if [ ! -e "./spark/archive/${spark_file_name}" ]; then
        echo "${spark_file_name} not found, start to download file..."
        wget -P "./spark/archive" "${spark_base_url}/${spark_file_name}"
    else
        echo "File ${spark_file_name} exist..."
    fi

    if [ ! -e "./spark/archive/spark-${SPARK_VERSION}-bin-hadoop3" ]; then
        echo "Extract ${spark_file_name}..."
        tar xf "./spark/archive/${spark_file_name}" -C ./spark/archive/
    fi
}

function mount_spark() {
    for host in $(ansible-inventory -i inventory --list | jq -r '.hadoop.hosts[]'); do
        echo "Mount ./spark/archive/spark-${SPARK_VERSION}-bin-hadoop3..."
        multipass mount "./spark/archive/spark-${SPARK_VERSION}-bin-hadoop3" "$host":/home/ubuntu/spark
    done
}

function install_spark() {
    ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i inventory ./spark/install_spark.yaml
}

function unmount_spark() {
    for host in $(ansible-inventory -i inventory --list | jq -r '.hadoop.hosts[]'); do
        echo "Unmount $host:/home/ubuntu/spark..."
        multipass unmount "$host":/home/ubuntu/spark
    done
}

download_spark
mount_spark
install_spark
unmount_spark
