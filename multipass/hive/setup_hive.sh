#!/bin/bash

HIVE_VERSION="hive-4.0.1"
HIVE_STANDALONE_METASTORE="hive-standalone-metastore-3.0.0"
HIVE_METASTORE="hive-metastore-3.0.0"

function download_hive() {
    local base_url="https://mirrors.tuna.tsinghua.edu.cn/apache/hive"
    hive_file_name="apache-${HIVE_VERSION}-bin.tar.gz"
    hive_standalone_metastore_file_name="${HIVE_STANDALONE_METASTORE}-bin.tar.gz"

    if [ ! -e "./hive/archive/${hive_file_name}" ]; then
        echo "${hive_file_name} not found, start to download file..."
        wget -P "./hive/archive" "${base_url}/${HIVE_VERSION}/${hive_file_name}"
    else
        echo "File ${hive_file_name} exist..."
    fi

    if [ ! -e "./hive/archive/apache-${HIVE_VERSION}-bin" ]; then
        echo "Extract ${hive_file_name}..."
        tar xf "./hive/archive/${hive_file_name}" -C ./hive/archive/
    fi

    if [ ! -e "./hive/archive/${hive_standalone_metastore_file_name}" ]; then
        echo "${hive_standalone_metastore_file_name} not found, start to download file..."
        wget -P "./hive/archive" "${base_url}/${HIVE_STANDALONE_METASTORE}/${hive_standalone_metastore_file_name}"
    else
        echo "File ${hive_file_name} exist..."
    fi

    if [ ! -e "./hive/archive/apache-${HIVE_METASTORE}-bin" ]; then
        echo "Extract ${hive_standalone_metastore_file_name}..."
        tar xf "./hive/archive/${hive_standalone_metastore_file_name}" -C ./hive/archive/
    fi
}

download_hive