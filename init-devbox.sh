echo "START: init-devbox"

echo '' >> /home/vagrant/.bashrc
echo 'export DOCKER_HOST="tcp://192.168.7.100:2376"' >> /home/vagrant/.bashrc
echo 'alias swarm-ps="docker ps --format \"table {{.Names}}\t{{.ID}}\t{{.Status}}\t{{.Image}}\t{{.Command}}\""' >> /home/vagrant/.bashrc

echo "END: init-devbox"
