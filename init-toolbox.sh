echo "START: init-toolbox"

docker run -d --restart=always -p 5000:5000 --name registry registry:2
sleep 10s

docker pull progrium/consul
docker tag progrium/consul toolbox:5000/progrium-consul
docker push toolbox:5000/progrium-consul

docker pull swarm
docker tag swarm toolbox:5000/swarm
docker push toolbox:5000/swarm

mkdir -p /var/consul
docker run -d --restart=always -h toolbox -v /var/consul:/data \
    -p 192.168.7.100:8300:8300 \
    -p 192.168.7.100:8301:8301 \
    -p 192.168.7.100:8301:8301/udp \
    -p 192.168.7.100:8302:8302 \
    -p 192.168.7.100:8302:8302/udp \
    -p 192.168.7.100:8400:8400 \
    -p 8500:8500 \
    -p 192.168.7.100:53:53/udp \
    toolbox:5000/progrium-consul -server -advertise 192.168.7.100 -bootstrap-expect 4

docker run -d --restart=always -p 192.168.7.100:2376:2375 toolbox:5000/swarm manage consul://192.168.7.100:8500

echo "END: init-toolbox"
