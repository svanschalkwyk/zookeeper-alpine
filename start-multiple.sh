docker run  -d --name=zk1 zk 1
export IP1=$(docker inspect zk1 | grep \"IPAddress | awk '{print $2}' | egrep -o '([0-9]+\.){3}[0-9]+' | head -n1)
docker run -d --name=zk2 zk 2 $IP1
docker run -d --name=zk3 zk 3 $IP1


