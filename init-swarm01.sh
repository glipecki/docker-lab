echo "START: init-swarm01"

mkdir -p /var/consul
docker run -d -h swarm01 -v /var/consul:/data \
    -p 192.168.7.101:8300:8300 \
    -p 192.168.7.101:8301:8301 \
    -p 192.168.7.101:8301:8301/udp \
    -p 192.168.7.101:8302:8302 \
    -p 192.168.7.101:8302:8302/udp \
    -p 192.168.7.101:8400:8400 \
    -p 192.168.7.101:8500:8500 \
    -p 192.168.7.101:53:53/udp \
    toolbox:5000/progrium-consul -server -advertise 192.168.7.101 -join 192.168.7.100

docker run -d toolbox:5000/swarm join --addr=192.168.7.101:2375 consul://192.168.7.101:8500

echo "END: init-swarm01"
