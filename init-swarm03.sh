echo "START: init-swarm03"

mkdir -p /var/consul
docker run -d --restart=always -h swarm03 -v /var/consul:/data \
    -p 192.168.7.103:8300:8300 \
    -p 192.168.7.103:8301:8301 \
    -p 192.168.7.103:8301:8301/udp \
    -p 192.168.7.103:8302:8302 \
    -p 192.168.7.103:8302:8302/udp \
    -p 192.168.7.103:8400:8400 \
    -p 192.168.7.103:8500:8500 \
    -p 192.168.7.103:53:53/udp \
    toolbox:5000/progrium-consul -server -advertise 192.168.7.103 -join 192.168.7.100

docker run -d --restart=always toolbox:5000/swarm join --addr=192.168.7.103:2375 consul://192.168.7.103:8500

docker run -d --restart=always --name=registrator --net=host --volume=/var/run/docker.sock:/tmp/docker.sock toolbox:5000/registrator consul://192.168.7.103:8500

echo "END: init-swarm03"
