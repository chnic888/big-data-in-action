# Install Apache Hadoop

This guide will help you set up and validate the Apache Hadoop environment.

---

## Step 1: Setup Hadoop Environment

1. Run the `setup_hadoop.sh` script to install and configure Hadoop:
   ```bash
   ./hadoop/setup_hadoop.sh
   ```

2. Log in to the **vm01** instance and start HDFS and YARN services using the `start-all.sh` script:
   ```bash
   ssh ubuntu@vm01

   /opt/hadoop/sbin/start-all.sh
   ```

---

## Step 2: Validate Hadoop Cluster

### Verify HDFS and YARN Services

- **Check HDFS Health**:
  [http://vm01:9870/dfshealth.html#tab-overview](http://vm01:9870/dfshealth.html#tab-overview)

- **Check YARN Node Status**:
  [http://vm01:8088/cluster/nodes](http://vm01:8088/cluster/nodes)

---

## Step 3: Submit a MapReduce Application

Submit a MapReduce example application to test the cluster functionality. The application can be submitted on either the
cluster or a local machine:

1. SSH into the **vm01** instance:
   ```bash
   ssh ubuntu@vm01
   ```

2. Run the MapReduce example job to calculate the value of Pi:
   ```bash
   /opt/hadoop/bin/hadoop jar /opt/hadoop/share/hadoop/mapreduce/hadoop-mapreduce-examples-3.4.0.jar pi 3 3
   ```