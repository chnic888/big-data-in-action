# Big Data Integration Environment Setup

This project uses **Multipass** to quickly create an integrated big data environment for learning and experimentation.
The environment includes **Hadoop**, **Hive**, and **Spark**.

## Prerequisites

- **Operating System**: Linux / macOS
- **Dependencies**:
    - **Multipass**: Virtual machine manager for lightweight Linux VMs
    - **Ansible**: Version `2.10` or higher

---

## Environment Overview

This setup includes:

1. **Multipass VM Cluster**: Virtual machines based on `Ubuntu 22.04 LTS`.
2. **Hadoop Environment**: Apache Hadoop version `3.4.0`.
3. **Hive Environment**: Apache Hive version `3.1.3`.
4. **Spark Environment**: Apache Spark version `3.5.3`.

---

## Installation Guide

### 1. Build a Multipass VM Cluster

Follow the [Multipass Cluster Setup Guide](./vm/README.md) to create a cluster of virtual machines running **Ubuntu
22.04 LTS**.

### 2. Setup Apache Hadoop

Install and configure Apache Hadoop by following the [Hadoop Environment Setup Guide](./hadoop/README.md).  
**Version**: `3.4.0`

### 3. Setup Apache Hive

Install and configure Apache Hive using the [Hive Environment Setup Guide](./hive/README.md).  
**Version**: `3.1.3`

### 4. Setup Apache Spark

Install and configure Apache Spark by following the [Spark Environment Setup Guide](./spark/README.md).  
**Version**: `3.5.3`

