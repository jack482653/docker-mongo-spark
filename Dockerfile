FROM ubuntu:14.04

# See https://github.com/phusion/baseimage-docker/issues/58
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

RUN apt-get update \
    && apt-get install -y wget ipython build-essential python-dev python-pip openjdk-7-jdk git

ENV SOURCE_REPO 16945b8129c5c1ba7644
ENV SOURCE_BRANCH 8224989bc02318fff583a47cc16ce7192763d74f
ENV SOURCE_URL https://gist.githubusercontent.com/jack482653/${SOURCE_REPO}/raw/${SOURCE_BRANCH}/sources.list

RUN wget -qO - $(SOURCE_URL} > /etc/sources.list

RUN apt-get update \
    && apt-get install -y git python-numpy python-scipy python-matplotlib \
    && apt-get install -y ipython ipython-notebook python-pandas python-sympy python-nose \
    && apt-get install -y zlibc zlib1g zlib1g-dev libjpeg-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* 

RUN pip install pymongo

ENV SPARK_VERSION 1.5.2
ENV HADOOP_VERSION 2.6
ENV MONGO_HADOOP_VERSION 1.5.0
ENV MONGO_HADOOP_COMMIT 9905150ec5f8f7b74bc998cc36f53d0a6f83ee49

ENV JAVA_HOME /usr/lib/jvm/java-7-openjdk-amd64
ENV SPARK_HOME /usr/local/spark

ENV APACHE_MIRROR http://ftp.ps.pl/pub/apache
ENV SPARK_URL ${APACHE_MIRROR}/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz
ENV SPARK_DIR spark-${SPARK_VERSION}-bin-hadoop2.6

ENV MONGO_HADOOP_URL https://github.com/mongodb/mongo-hadoop/archive/${MONGO_HADOOP_COMMIT}.tar.gz

ENV MONGO_HADOOP_LIB_PATH /usr/local/mongo-hadoop/build/libs
ENV MONGO_HADOOP_JAR  ${MONGO_HADOOP_LIB_PATH}/mongo-hadoop-${MONGO_HADOOP_VERSION}-SNAPSHOT.jar

ENV MONGO_HADOOP_SPARK_PATH /usr/local/mongo-hadoop/spark
ENV MONGO_HADOOP_SPARK_JAR ${MONGO_HADOOP_SPARK_PATH}/build/libs/mongo-hadoop-spark-${MONGO_HADOOP_VERSION}-SNAPSHOT.jar
ENV PYTHONPATH  ${MONGO_HADOOP_SPARK_PATH}/src/main/python

ENV SPARK_DRIVER_EXTRA_CLASSPATH ${MONGO_HADOOP_JAR}:${MONGO_HADOOP_SPARK_JAR}
ENV CLASSPATH ${SPARK_DRIVER_EXTRA_CLASSPATH}
ENV JARS ${MONGO_HADOOP_JAR},${MONGO_HADOOP_SPARK_JAR}

ENV PYSPARK_DRIVER_PYTHON /usr/bin/ipython
ENV PATH $PATH:$SPARK_HOME/bin

# Download  Spark
RUN wget -qO - ${SPARK_URL} | tar -xz -C /usr/local/ \
    && cd /usr/local && ln -s ${SPARK_DIR} spark

RUN wget -qO - ${MONGO_HADOOP_URL} | tar -xz -C /usr/local/ \
    && mv /usr/local/mongo-hadoop-${MONGO_HADOOP_COMMIT} /usr/local/mongo-hadoop \
    && cd /usr/local/mongo-hadoop \
    && ./gradlew jar

RUN echo "spark.driver.extraClassPath   ${CLASSPATH}" > $SPARK_HOME/conf/spark-defaults.conf

CMD ["/bin/bash"]

