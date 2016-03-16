# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|

  config.vm.box = "debian/jessie64"
  config.vm.network "public_network", bridge: "en0: Wi-Fi (AirPort)"
  config.vm.provision "shell", inline: <<-SHELL
    apt-get update
    apt-get -y install apt-transport-https ca-certificates
    apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
    echo "deb https://apt.dockerproject.org/repo debian-jessie main" > /etc/apt/sources.list.d/docker.list
    apt-get update
    apt-get -y install docker-engine
    sudo gpasswd -a vagrant docker
    service docker start
  SHELL

  config.vm.define "toolbox", primary: true do |toolbox|
    # registry, apache lb, etc
  end

  config.vm.define "devbox", primary: true do |devbox|
    # for developer
  end

  config.vm.define "swarm01" do |swarm01|
  end

  config.vm.define "swarm02" do |swarm02|
  end

  config.vm.define "swarm03" do |swarm03|
  end

  config.vm.define "swarm04" do |swarm04|
  end

  config.vm.define "swarm05" do |swarm05|
  end

end
