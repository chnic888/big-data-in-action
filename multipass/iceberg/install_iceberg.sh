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

download_iceberg_spark_runtime
download_iceberg_hive_runtime