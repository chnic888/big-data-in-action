#!/bin/bash

ICEBERG_VERSION="1.7.0"

function download_iceberg_spark_runtime() {
    local base_url="https://repo1.maven.org/maven2/org/apache/iceberg/iceberg-spark-runtime-3.5_2.12/$ICEBERG_VERSION"
    file_name="iceberg-spark-runtime-3.5_2.12-$ICEBERG_VERSION.jar"

    if [ ! -e "./iceberg/archive/${file_name}" ]; then
        echo "${file_name} not found, start to download file..."
        wget -P "./iceberg/archive" "${base_url}/${file_name}"
    else
        echo "File ${file_name} exist..."
    fi
}

function download_iceberg_hive_runtime() {
    local base_url="https://repo1.maven.org/maven2/org/apache/iceberg/iceberg-hive-runtime/$ICEBERG_VERSION"
    file_name="iceberg-hive-runtime-$ICEBERG_VERSION.jar"

    if [ ! -e "./iceberg/archive/${file_name}" ]; then
        echo "${file_name} not found, start to download file..."
        wget -P "./iceberg/archive" "${base_url}/${file_name}"
    else
        echo "File ${file_name} exist..."
    fi
}

function transfer_iceberg_jars() {
    for host in $(ansible-inventory -i inventory --list | jq -r '.vm.hosts[]'); do
        echo "Transfer iceberg jar to $host..."
        multipass transfer "./iceberg/archive/iceberg-hive-runtime-$ICEBERG_VERSION.jar" "$host":/home/ubuntu
        multipass transfer "./iceberg/archive/iceberg-spark-runtime-3.5_2.12-$ICEBERG_VERSION.jar" "$host":/home/ubuntu
    done
}

function install_iceberg() {
    ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i inventory ./iceberg/install_iceberg.yaml --extra-vars "{'iceberg_version': $ICEBERG_VERSION}"
}

download_iceberg_spark_runtime
download_iceberg_hive_runtime
transfer_iceberg_jars
install_iceberg