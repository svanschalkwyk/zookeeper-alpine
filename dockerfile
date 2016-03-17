FROM iron/base
MAINTAINER svanschalkwyk <step@remcam.net>
# http://container-solutions.com/dynamic-zookeeper-cluster-with-docker/

# openjdk-8-base contains no GUI support. see https://pkgs.alpinelinux.org/package/testing/x86_64/openjdk8-jre-base
RUN echo '@edge http://nl.alpinelinux.org/alpine/edge/main' >> /etc/apk/repositories \
  && echo '@community http://nl.alpinelinux.org/alpine/edge/community' >> /etc/apk/repositories \
  && apk update \
  && apk upgrade \
  && apk add openjdk8-jre-base@community \
  && rm -rf /var/cache/apk/*

RUN apk add --update bash git

# puts javac in the PATH
ENV PATH=/usr/lib/jvm/java-1.8-openjdk/bin:/usr/lib/jvm/java-1.8-openjdk/jre/lib/amd64/jli:$PATH
ENV LD_LIBRARY_PATH=/usr/lib/jvm/java-1.8-openjdk/jre/lib/amd64/jli:/tmp/zookeeper/build/lib:$LD_LIBRARY_PATH
ENV JAVA_HOME=/usr/lib/jvm/java-1.8-openjdk

RUN mkdir /tmp/zookeeper
WORKDIR /tmp/zookeeper
RUN git clone https://github.com/apache/zookeeper.git .
ADD build.tar.gz /tmp/zookeeper

RUN cp /tmp/zookeeper/conf/zoo_sample.cfg /tmp/zookeeper/conf/zoo.cfg
RUN echo "standaloneEnabled=false" >> /tmp/zookeeper/conf/zoo.cfg
RUN echo "dynamicConfigFile=/tmp/zookeeper/conf/zoo.cfg.dynamic" >> /tmp/zookeeper/conf/zoo.cfg
ADD zk-init.sh /usr/local/bin/
ENTRYPOINT ["/usr/local/bin/zk-init.sh"]



