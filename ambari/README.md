# Ambari Installation

## Getting Started

Build Ambari installation artifacts from source code

### Prerequisites

- Ubuntu 22.04(amd64)
- Java 8
- Python 2
- Apache Maven

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

Find the root directory of Java 8 and export it as the `JAVA_HOM`E variable before executing the mvn command.

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

### Build Ambari Deb Package

Append the `-Drat.skip=true` parameter to `mvn` commend to disable `apache-rat-plugin` plugin

```shell
mvn -B clean install jdeb:jdeb -DnewVersion=2.7.8.0.0 -DbuildNumber=da8f1b9b5a799bfa8e2d8aa9ab31d6d5a1cc31a0 -DskipTests -Dpython.ver="python >= 2.6" -Drat.skip=true
```
