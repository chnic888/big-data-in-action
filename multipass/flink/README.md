# Install Apache Hadoop

This guide will help you set up and validate the Apache Flink environment.

---

## Step 1: Setup Flink Environment

1. Run the `install_flink.sh` script to configure Flink in standalone mode:

   ```bash
   ./flink/install_flink.sh
   ```

2. Log in to the **vm01** instance and start the Flink services:

   ```bash
   ssh ubuntu@vm01

   /opt/flink/bin/start-cluster.sh
   ```

---

## Step 2: Validate Flink

### Verify Flink Service

- **Check Flink Running Status**: [http://vm01:8081/](http://vm01:8081/)

### Submit a Test Application

1. Log in to the **vm01** instance:

   ```bash
   ssh ubuntu@vm01
   ```

2. Submit a test Spark application

   ```bash
   /opt/flink/bin/flink run /opt/flink/examples/streaming/WordCount.jar
   ```

3. Validate the jos status from [Apache Flink Dashboard](http://vm01:8081/)
