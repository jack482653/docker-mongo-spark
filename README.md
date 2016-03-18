PySpark + development version of [Mongo Hadoop](https://github.com/mongodb/mongo-hadoop). 

# Usage

You can modify the virsion of `SPARK_VERSION` to get the newest Spark. If you want to get newest version of Mongo-Hadoop, you have to update the ENV of `MONGO_HADOOP_VERSION` and `MONGO_HADOOP_COMMIT`.

## Build image

    sudo docker build -t zero323/mongo-spark --build-arg IP={YOUR-IP} .

## Run image

    sudo docker run -t -i --net=host --env SPARK_LOCAL_IP=$DOCKER_HOSTNAME zero323/mongo-spark /bin/bash

For details see: [Getting Spark, Python, and MongoDB to work together](http://stackoverflow.com/q/33391840/1560062)

# Reference
* [Getting Spark, Python, and MongoDB to work together](http://stackoverflow.com/q/33391840/1560062)
* [Install Apache Spark on Ubuntu-14.04](http://blog.prabeeshk.com/blog/2014/10/31/install-apache-spark-on-ubuntu-14-dot-04/)
