# Install Apache Hive

This guide explains how to set up Hive Metastore Server, Hive on a Hadoop cluster, and validate the Hive environment.

---

## Step 1: Setup Hive Metastore Server

1. Run the `setup_metastore.sh` script to configure the Hive Metastore Server:
   ```bash
   ./hive/setup_metastore.sh
   ```

2. Log in to the **vm00** instance and start the Metastore service in the background:
   ```bash
   ssh ubuntu@vm00

   nohup /opt/hive/bin/hive --service metastore > /opt/hive/logs/metastore.log 2>&1 &
   ```

---

## Step 2: Setup Hive on Hadoop Cluster

1. Run the `setup_hive.sh` script to configure Hive on the Hadoop cluster:
   ```bash
   ./hive/setup_hive.sh
   ```

2. Log in to the **vm01** instance and start the HiveServer2 service in the background:
   ```bash
   ssh ubuntu@vm01

   nohup /opt/hive/bin/hiveserver2 > /opt/hive/logs/hiveserver2.log 2>&1 &
   ```

---

## Step 3: Validate Hive

### Verify HiveServer2 Service

- **Check HiveServer2 Running Status**: [http://vm01:10002/](http://vm01:10002/)

### Access HiveServer2

1. Log in to the **vm01** instance:
   ```bash
   ssh ubuntu@vm01
   ```

2. Connect to HiveServer2 using Beeline:
   ```bash
   /opt/hive/bin/beeline -u jdbc:hive2://vm01:10000 -n ubuntu
   ```

---

## Step 4: Test Hive on Hadoop Cluster

1. After logging into HiveServer2 via Beeline, create a test table and populate it with data:
   ```sql
   CREATE TABLE test_table (id INT, name STRING);
   INSERT INTO test_table VALUES
      (1, 'Alice'),
      (2, 'Bob'),
      (3, 'Charlie'),
      (4, 'Diana'),
      (5, 'Ethan'),
      (6, 'Fiona'),
      (7, 'George'),
      (8, 'Hannah'),
      (9, 'Ian'),
      (10, 'Jasmine'),
      (11, 'Kevin'),
      (12, 'Luna'),
      (13, 'Mike'),
      (14, 'Nina'),
      (15, 'Oscar'),
      (16, 'Paula'),
      (17, 'Quinn'),
      (18, 'Rachel'),
      (19, 'Steve'),
      (20, 'Tina');
   ```

2. Confirm that the test data is successfully stored and retrieved.
   ```sql
   SELECT * FROM test_table;
   ```