# Ambari Installation

## Getting Started

Build Ambari installation artifacts from source code

### Prerequisites

- Ubuntu 22.04(amd64)
- Java 8
- Python 2.7
- Apache Maven 3.6.3
- Postgress 14

## Install Build Tools

Installing the required tools to build Ambari from scratch in a fresh Ubuntu 22.04 environment.

```shell
sudo apt install openjdk-8-jdk-headless

sudo apt install python2
sudo apt install python2-dev
sudo ln -s /usr/bin/python2 /usr/bin/python

sudo apt install maven
```

## Build Ambari for Ubuntu/Debian

Official build guide https://cwiki.apache.org/confluence/display/AMBARI/Installation+Guide+for+Ambari+2.7.6

### Download Source Code

Download the source code of Ambari 2.7.8 to the project root directory and extract it.

```shell
wget https://dlcdn.apache.org/ambari/ambari-2.7.8/apache-ambari-2.7.8-src.tar.gz

tar xfvz apache-ambari-2.7.8-src.tar.gz
```

### Add Third Part Maven Repository (Optional)

Add a third part maven repository to speed up the build. The following configuration is a third maven repo from Alibaba.

- Add this `<pluginRepository>` block within the `<pluginRepositories>` section of pom.xml file

```xml
<!--apache-ambari-2.7.8-src/pom.xml-->
<pluginRepository>
    <id>aliyunmaven</id>
    <name>Aliyun Maven Plugin Repository</name>
    <url>https://maven.aliyun.com/repository/public</url>
    <releases>
        <enabled>true</enabled>
    </releases>
    <snapshots>
        <enabled>false</enabled>
    </snapshots>
</pluginRepository>
```

- Add this `<repository>` block within the `<repositories>` section of pom.xml file

```xml
<!--apache-ambari-2.7.8-src/pom.xml-->
<repository>
    <id>aliyunmaven</id>
    <name>Aliyun Maven Repository</name>
    <url>https://maven.aliyun.com/repository/public</url>
    <releases>
        <enabled>true</enabled>
    </releases>
    <snapshots>
        <enabled>false</enabled>
    </snapshots>
</repository>
```

### Set Build Version

Find the root directory of Java 8 and export it as the `JAVA_HOME` variable before executing the mvn command.

```shell
export JAVA_HOME="/usr/lib/jvm/java-8-openjdk-amd64"

cd apache-ambari-2.7.8-src
mvn versions:set -DnewVersion=2.7.8.0.0
 
pushd ambari-metrics
mvn versions:set -DnewVersion=2.7.8.0.0
popd
```

### Update the Deprecated Bower Registry URL

As Bower is deprecating their registry hosted with Heroku (https://bower.herokuapp.com), therefore, the old registry url
should be replaced by new url(https://registry.bower.io). In addition, the strict SSL authentication needs to be turned
off due to invalid certificate.

```bash
echo '{
    "directory": "app/bower_components",
    "registry": "https://registry.bower.io",
    "strict-ssl": false
}' > new_bowerrc.json


mv new_bowerrc.json ./ambari-admin/src/main/resources/ui/admin-web/.bowerrc
```

### Update Legacy Restlet Repository

Update the legacy Restlet Repository due to the repo has an invalid ssl certificate

```bash
sed -i 's#https://maven.restlet.com#https://maven.restlet.talend.com#g' ./ambari-logsearch/pom.xml
```

### Change HDP Component Download URL (Optional)

Modify the download paths of some components in HDP to accelerate downloading. You can modify the specific mirror
addresses according to your local network situation.

```shell
sed -i 's#https://dl.grafana.com/oss/release/grafana-6.7.4.linux-amd64.tar.gz#https://mirrors.huaweicloud.com/grafana/6.7.4/grafana-6.7.4.linux-amd64.tar.gz#g' ./ambari-metrics/pom.xml

sed -i 's#https://downloads.apache.org/phoenix/phoenix-5.1.2/phoenix-hbase-2.4-5.1.2-bin.tar.gz#https://dlcdn.apache.org/phoenix/phoenix-5.1.2/phoenix-hbase-2.4-5.1.2-bin.tar.gz#g' ./ambari-metrics/pom.xml
```

### Build Ambari Deb Package

Append the `-Drat.skip=true` parameter to `mvn` commend to disable `apache-rat-plugin` plugin.

```shell
mvn -B clean install jdeb:jdeb -DnewVersion=2.7.8.0.0 -DbuildNumber=da8f1b9b5a799bfa8e2d8aa9ab31d6d5a1cc31a0 -DskipTests -Dpython.ver="python >= 2.7" -Drat.skip=true
```

#### Build Result

```shell
[INFO] ------------------------------------------------------------------------
[INFO] Reactor Summary:
[INFO] 
[INFO] Ambari Main 2.7.8.0.0 .............................. SUCCESS [  3.120 s]
[INFO] Apache Ambari Project POM 2.7.8.0.0 ................ SUCCESS [  0.021 s]
[INFO] Ambari Web 2.7.8.0.0 ............................... SUCCESS [ 47.100 s]
[INFO] Ambari Views 2.7.8.0.0 ............................. SUCCESS [  1.027 s]
[INFO] Ambari Admin View 2.7.8.0.0 ........................ SUCCESS [01:06 min]
[INFO] ambari-utility 1.0.0.0-SNAPSHOT .................... SUCCESS [  9.237 s]
[INFO] ambari-metrics 2.7.8.0.0 ........................... SUCCESS [  0.625 s]
[INFO] Ambari Metrics Common 2.7.8.0.0 .................... SUCCESS [  4.804 s]
[INFO] Ambari Metrics Hadoop Sink 2.7.8.0.0 ............... SUCCESS [  2.702 s]
[INFO] Ambari Metrics Flume Sink 2.7.8.0.0 ................ SUCCESS [  0.863 s]
[INFO] Ambari Metrics Kafka Sink 2.7.8.0.0 ................ SUCCESS [  1.229 s]
[INFO] Ambari Metrics Storm Sink 2.7.8.0.0 ................ SUCCESS [  1.710 s]
[INFO] Ambari Metrics Storm Sink (Legacy) 2.7.8.0.0 ....... SUCCESS [  1.706 s]
[INFO] Ambari Metrics Collector 2.7.8.0.0 ................. SUCCESS [22:44 min]
[INFO] Ambari Metrics Monitor 2.7.8.0.0 ................... SUCCESS [  0.863 s]
[INFO] Ambari Metrics Grafana 2.7.8.0.0 ................... SUCCESS [  2.773 s]
[INFO] Ambari Metrics Host Aggregator 2.7.8.0.0 ........... SUCCESS [  9.211 s]
[INFO] Ambari Metrics Assembly 2.7.8.0.0 .................. SUCCESS [01:18 min]
[INFO] Ambari Service Advisor 1.0.0.0-SNAPSHOT ............ SUCCESS [  1.585 s]
[INFO] Ambari Server 2.7.8.0.0 ............................ SUCCESS [03:29 min]
[INFO] Ambari Functional Tests 2.7.8.0.0 .................. SUCCESS [  0.459 s]
[INFO] Ambari Agent 2.7.8.0.0 ............................. SUCCESS [ 28.030 s]
[INFO] ambari-logsearch 2.7.8.0.0 ......................... SUCCESS [  0.383 s]
[INFO] Ambari Logsearch Appender 2.7.8.0.0 ................ SUCCESS [  0.159 s]
[INFO] Ambari Logsearch Config Api 2.7.8.0.0 .............. SUCCESS [  0.094 s]
[INFO] Ambari Logsearch Config JSON 2.7.8.0.0 ............. SUCCESS [  0.072 s]
[INFO] Ambari Logsearch Config Solr 2.7.8.0.0 ............. SUCCESS [  0.060 s]
[INFO] Ambari Logsearch Config Zookeeper 2.7.8.0.0 ........ SUCCESS [  0.067 s]
[INFO] Ambari Logsearch Config Local 2.7.8.0.0 ............ SUCCESS [  0.050 s]
[INFO] Ambari Logsearch Log Feeder Plugin Api 2.7.8.0.0 ... SUCCESS [  0.087 s]
[INFO] Ambari Logsearch Log Feeder Container Registry 2.7.8.0.0 SUCCESS [  0.202 s]
[INFO] Ambari Logsearch Log Feeder 2.7.8.0.0 .............. SUCCESS [  5.116 s]
[INFO] Ambari Logsearch Web 2.7.8.0.0 ..................... SUCCESS [02:20 min]
[INFO] Ambari Logsearch Server 2.7.8.0.0 .................. SUCCESS [  6.274 s]
[INFO] Ambari Logsearch Assembly 2.7.8.0.0 ................ SUCCESS [  0.053 s]
[INFO] Ambari Logsearch Integration Test 2.7.8.0.0 ........ SUCCESS [  0.606 s]
[INFO] ambari-infra 2.7.8.0.0 ............................. SUCCESS [  0.037 s]
[INFO] Ambari Infra Solr Client 2.7.8.0.0 ................. SUCCESS [05:38 min]
[INFO] Ambari Infra Solr Plugin 2.7.8.0.0 ................. SUCCESS [  0.371 s]
[INFO] Ambari Infra Manager 2.7.8.0.0 ..................... SUCCESS [  6.397 s]
[INFO] Ambari Infra Assembly 2.7.8.0.0 .................... SUCCESS [  0.062 s]
[INFO] Ambari Infra Manager Integration Tests 2.7.8.0.0 ... SUCCESS [  1.784 s]
[INFO] ------------------------------------------------------------------------
[INFO] BUILD SUCCESS
[INFO] ------------------------------------------------------------------------
[INFO] Total time:  39:01 min
[INFO] ------------------------------------------------------------------------
```

#### Build Artifacts

Use the find command `find ./ -type f -name *.deb` to locate the deb artifacts and 2 deb packages could be found.

```shell
./ambari-server/target/ambari-server_2.7.8.0-0-dist.deb
./ambari-agent/target/ambari-agent_2.7.8.0-0.deb
```

## Install Ambari Server

Install the sever deb package `ambari-server_2.7.8.0-0-dist.deb` using the `apt install` command on multipass host.

```shell
sudo apt install postgresql postgresql-contrib

sudo apt install ./ambari-server/target/ambari-server_2.7.8.0-0-dist.deb
```

## Setup and Start Ambari Server

## Install and Start Ambari Agent on All Agent Hosts

Install the agent deb package `ambari-agent_2.7.8.0-0.deb` using the `apt install` command on multipass VM instances.

```shell
sudo apt-get install ./ambari-agent_2.7.8.0-0.deb
```