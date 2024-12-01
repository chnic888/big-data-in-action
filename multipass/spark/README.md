# Install Apache Spark

This guide provides steps to set up Apache Spark in standalone deploy mode and validate its installation.

---

## Step 1: Setup Spark Environment

1. Run the `install_spark.sh` script to configure Spark in standalone mode:
   ```bash
   ./spark/install_spark.sh
   ```

2. Log in to the **vm01** instance and start the Spark services:
   ```bash
   ssh ubuntu@vm01

   /opt/spark/sbin/start-all.sh
   ```

---

## Step 2: Validate Spark

### Verify Spark Service

- **Check Spark Running Status**: [http://vm01:8080/](http://vm01:8080/)

### Submit a Test Application

1. Log in to the **vm01** instance:
   ```bash
   ssh ubuntu@vm01
   ```

2. Submit a test Spark application (e.g., calculating Pi):
   ```bash
   /opt/spark/bin/spark-submit \
       --class org.apache.spark.examples.SparkPi \
       --deploy-mode client \
       --executor-memory 1G \
       --num-executors 10 \
       /opt/spark/examples/jars/spark-examples_2.12-3.5.3.jar 100
   ```
3. Check the Spark UI or logs to ensure the application ran successfully.