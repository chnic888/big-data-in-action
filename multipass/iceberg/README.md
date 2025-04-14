# Install Apache Iceberg

---

## Step 1: Install Iceberg

1. Run the `install_iceberg.sh` script to copy iceberg jars to hive and hadoop
   ```shell
   ./iceberg/install_iceberg.sh
   ```
   

```shell
spark-sql \
--packages org.apache.iceberg:iceberg-spark-runtime-3.5_2.12:1.7.0 \
--conf spark.sql.extensions=org.apache.iceberg.spark.extensions.IcebergSparkSessionExtensions \
--conf spark.sql.catalog.my_iceberg_catalog=org.apache.iceberg.spark.SparkCatalog \
--conf spark.sql.catalog.my_iceberg_catalog.type=hive \
--conf spark.sql.catalog.my_iceberg_catalog.uri=thrift://vm00:9083 \
--conf spark.sql.catalog.my_iceberg_catalog.warehouse=hdfs:///user/hive/warehouse
```

```sql
CREATE DATABASE IF NOT EXISTS my_company;

CREATE TABLE my_iceberg_catalog.my_db.my_table
(
    id   BIGINT,
    name STRING,
    age  INT,
    ts   TIMESTAMP
) USING iceberg;

INSERT INTO my_iceberg_catalog.my_db.my_table
VALUES (1, 'Alice', 30, CURRENT_TIMESTAMP()),
       (2, 'Bob', 25, CURRENT_TIMESTAMP()),
       (3, 'Charlie', 35, CURRENT_TIMESTAMP());

SELECT *
FROM my_iceberg_catalog.my_db.my_table;
```

```shell
spark-sql \
--packages org.apache.iceberg:iceberg-spark-runtime-3.5_2.12:1.7.0 \
--conf spark.sql.extensions=org.apache.iceberg.spark.extensions.IcebergSparkSessionExtensions \
--conf spark.sql.catalog.spark_catalog=org.apache.iceberg.spark.SparkSessionCatalog \
--conf spark.sql.catalog.spark_catalog.type=hive \
--conf spark.sql.catalog.spark_catalog.uri=thrift://vm00:9083 \
--conf spark.sql.catalog.spark_catalog.warehouse=hdfs:///user/hive/warehouse
```

```sql

```