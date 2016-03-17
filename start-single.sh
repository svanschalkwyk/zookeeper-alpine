# https://hub.docker.com/_/solr/
docker run --name zookeeper -d -p 2181:2181 -p 2888:2888 -p 3888:3888 remcam/zookeeper 1
docker inspect zookeeper | grep IPAddress
docker run --name solr1 --link zookeeper:ZK -d -p 8983:8983 \
      solr \
      bash -c '/opt/solr/bin/solr start -f -z $ZK_PORT_2181_TCP_ADDR:$ZK_PORT_2181_TCP_PORT'
docker run --name solr2 --link zookeeper:ZK -d -p 8984:8983 \
      solr \
      bash -c '/opt/solr/bin/solr start -f -z $ZK_PORT_2181_TCP_ADDR:$ZK_PORT_2181_TCP_PORT'
Create a collection:
docker exec -i -t solr1 /opt/solr/bin/solr create_collection \
        -c collection1 -shards 2 -p 8983
