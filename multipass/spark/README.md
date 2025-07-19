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

### Verify Hive-Spark Integration

1. Log in to the **vm01** instance:
   ```bash
   ssh ubuntu@vm01
   ```

2. Submit a test Spark application (e.g., calculating Pi):
   ```shell
   /opt/spark/bin/spark-sql
   ```

   ```sql
   show databases;
   show tables;
   select * from test_table;
   ```

### Submit a Test Application

1. Log in to the **vm01** instance:
   ```bash
   ssh ubuntu@vm01
   ```

2. Submit a test Spark application (e.g., calculating Pi):
   ```bash
   /opt/spark/bin/spark-submit \
       --class org.apache.spark.examples.SparkPi \
       --master spark://vm01:7077 \
       --deploy-mode cluster \
       --executor-memory 1G \
       --num-executors 10 \
       /opt/spark/examples/jars/spark-examples_2.12-3.5.3.jar 100
   ```

3. Get submission id by Spark API server
   ```bash
   curl -X POST http://vm01:6066/v1/submissions/create \
     --header "Content-Type: application/json" \
     --data '{
       "action": "CreateSubmissionRequest",
       "appArgs": ["1000"],
       "appResource": "file:/opt/spark/examples/jars/spark-examples_2.12-3.5.3.jar",
       "clientSparkVersion": "3.5.3",
       "mainClass": "org.apache.spark.examples.SparkPi",
       "environmentVariables": {
         "SPARK_ENV_LOADED": "1"
       },
       "sparkProperties": {
         "spark.app.name": "SparkPi-REST",
         "spark.submit.deployMode": "cluster",
         "spark.master": "spark://vm01:7077",
         "spark.executor.memory": "1G",
         "spark.executor.instances": "10",
         "spark.jars": "file:/opt/spark/examples/jars/spark-examples_2.12-3.5.3.jar"
       }
     }'
   ```
4. Get the response
   ```json
   {
     "action": "CreateSubmissionResponse",
     "message": "Driver successfully submitted as driver-20250719223931-0002",
     "serverSparkVersion": "3.5.3",
     "submissionId": "driver-20250719223931-0002",
     "success": true
   }
   ```

5. Get the submission status by submissionId
   ```bash
   curl http://vm01:6066/v1/submissions/status/driver-20250719223931-0002
   ```
6. Get status of submission
   ```json
   {
     "action": "SubmissionStatusResponse",
     "driverState": "FINISHED",
     "serverSparkVersion": "3.5.3",
     "submissionId": "driver-20250719223931-0002",
     "success": true,
     "workerHostPort": "10.88.68.33:37487",
     "workerId": "worker-20250719220953-10.88.68.33-37487"
   }
   ```