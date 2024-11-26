# Install Apache Spark

## Setup Spark Environment

Run `setup_spark.sh` script to setup spark in standalone deploy mode

```shell
./spark/setup_spark.sh
```

Enter the shell of the `vm00` instance and start spark service

```shell
ssh ubuntu@vm01

/opt/spark/sbin/start-all.sh
```

## Validate Spark

Verify spark service via website

- Access http://vm01:8080/ to check tha availability of spark

Submit test application to cluster

```shell
ssh ubuntu@vm01

/opt/spark/bin/spark-submit --class org.apache.spark.examples.SparkPi --deploy-mode client --executor-memory 1G --num-executors 10 /opt/spark/examples/jars/spark-examples_2.12-3.5.3.jar 100
```