FROM apache/zeppelin:0.9.0
MAINTAINER Apache Software Foundation <dev@zeppelin.apache.org>

ENV SPARK_VERSION=3.0.1
ENV HADOOP_VERSION=3.2

USER root

COPY sources.list /etc/apt/sources.list
RUN  apt-get update

# support Kerberos certification
RUN export DEBIAN_FRONTEND=noninteractive && apt-get update && apt-get install -yq krb5-user libpam-krb5 && apt-get clean

RUN apt-get update && apt-get install -y curl unzip wget grep sed vim-tiny tzdata iputils-ping && apt-get clean


RUN rm -rf /spark
COPY resources/spark-3.0.1-bin-hadoop3.2.tgz spark-3.0.1-bin-hadoop3.2.tgz
RUN tar zxf spark-3.0.1-bin-hadoop3.2.tgz
RUN mv spark-3.0.1-bin-hadoop3.2 /spark
RUN rm spark-3.0.1-bin-hadoop3.2.tgz


RUN mkdir -p /hadoop/etc/hadoop
COPY core-site.xml /hadop/etc/hadoop/core-site.xml
COPY hdfs-site.xml /hadoop/etc/hadoop/hdfs-site.xml

ENV HADOOP_CONF_DIR=/hadoop/etc/hadoop/
ENV CORE_CONF_fs_defaultFS=hdfs://namenode:8020

WORKDIR /zeppelin
