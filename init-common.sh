# install docker
echo "START: init-common"

apt-get update
apt-get -y install apt-transport-https ca-certificates
apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
echo "deb https://apt.dockerproject.org/repo debian-jessie main" > /etc/apt/sources.list.d/docker.list
apt-get update
apt-get -y install docker-engine
gpasswd -a vagrant docker
cat <<EOF > /lib/systemd/system/docker.service
[Unit]
Description=Docker Application Container Engine
Documentation=https://docs.docker.com
After=network.target docker.socket
Requires=docker.socket

[Service]
Type=notify
ExecStart=/usr/bin/docker daemon -H tcp://0.0.0.0:2375 -H unix:///var/run/docker.sock -H fd:// --insecure-registry toolbox:5000
MountFlags=slave
LimitNOFILE=1048576
LimitNPROC=1048576
LimitCORE=infinity
TimeoutStartSec=0

[Install]
WantedBy=multi-user.target
EOF
systemctl daemon-reload
systemctl restart docker

# set /etc/hosts for internal network
echo "192.168.7.99   devbox" >> /etc/hosts
echo "192.168.7.100  toolbox" >> /etc/hosts
echo "192.168.7.101  swarm01" >> /etc/hosts
echo "192.168.7.102  swarm02" >> /etc/hosts
echo "192.168.7.103  swarm03" >> /etc/hosts

echo "END: init-common"
