echo "START: init-toolbox"

apt-get install -y apache2
a2enmod proxy
a2enmod proxy_http
a2enmod proxy_balancer
a2enmod lbmethod_bybusyness
a2enmod lbmethod_byrequests

cd /tmp
wget https://releases.hashicorp.com/consul-template/0.14.0/consul-template_0.14.0_linux_amd64.zip
unzip consul-template_0.14.0_linux_amd64.zip -d /opt/consul-template/

cat <<EOF > /opt/consul-template/apache.ctmpl
{{range services}}{{ if .Tags | contains "webapp" }}
<Proxy balancer://{{ .Name }}>
{{range service .Name }}  BalancerMember http://{{.Address}}:{{.Port}}
{{end}}
  ProxySet lbmethod=byrequests
</Proxy>

Redirect permanent /api/{{ .Name }} /api/{{ .Name }}/
ProxyPass /api/{{ .Name }}/ balancer://{{ .Name }}/
ProxyPassReverse /api/{{ .Name }}/ balancer://{{ .Name }}/

{{end}}{{end}}
EOF

cat <<EOF > /etc/systemd/system/multi-user.target.wants/consul-template.service
[Unit]
Description=consul-template
Requires=network-online.target
After=network-online.target

[Service]
Restart=on-failure
ExecStart=/opt/consul-template/consul-template -consul toolbox:8500 -template "/opt/consul-template/apache.ctmpl:/etc/apache2/sites-enabled/api-balancer.conf:systemctl reload apache2"

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl restart consul-template
systemctl restart apache2

docker run -d --restart=always -p 5000:5000 --name registry registry:2
sleep 10s

docker pull progrium/consul
docker tag progrium/consul toolbox:5000/progrium-consul
docker push toolbox:5000/progrium-consul

docker pull swarm
docker tag swarm toolbox:5000/swarm
docker push toolbox:5000/swarm

docker pull gliderlabs/registrator:latest
docker tag gliderlabs/registrator:latest toolbox:5000/registrator
docker push toolbox:5000/registrator

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

docker run -d --restart=always --name=registrator --net=host --volume=/var/run/docker.sock:/tmp/docker.sock toolbox:5000/registrator consul://192.168.7.100:8500

# docker kill -s HUP nginx

echo "END: init-toolbox"
