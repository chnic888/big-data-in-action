# Ambari Installation

## Getting Started

Build Ambari installation artifacts from source code

### Prerequisites

- Ubuntu 22.04(amd64)
- Java 8
- Python 2
- Apache Maven

## Install Build Tools

Installing the required tools to build Ambari from scratch in a fresh Ubuntu 22.04 environment

```shell
sudo apt install openjdk-8-jdk-headless

sudo apt install python2
sudo apt install python2-dev
sudo ln -s /usr/bin/python2 /usr/bin/python

sudo apt install maven
```

## Build Ambari for Ubuntu/Debian

Official build guide https://cwiki.apache.org/confluence/display/AMBARI/Installation+Guide+for+Ambari+2.7.6

```shell
wget https://dlcdn.apache.org/ambari/ambari-2.7.8/apache-ambari-2.7.8-src.tar.gz

tar xfvz apache-ambari-2.7.6-src.tar.gz
cd apache-ambari-2.7.6-src
```