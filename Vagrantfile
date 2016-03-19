# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|

  # config.vm.box = "debian/jessie64"
  config.vm.box = "debian/contrib-jessie64"

  # use with: vagrant plugin install vagrant-cachier
  if Vagrant.has_plugin?("vagrant-cachier")
    config.cache.scope = :box
  end

  config.vm.define "devbox", primary: true do |devbox|
    # for developer
    devbox.vm.hostname = "devbox"
    devbox.vm.network "private_network", ip: "192.168.7.99",
      virtualbox__intnet: "docker-lab-network"
    devbox.vm.provision "shell", path: "init-common.sh"
    devbox.vm.provision "shell", path: "init-devbox.sh"
  end

  config.vm.define "toolbox" do |toolbox|
    # registry, apache lb, etc
    toolbox.vm.hostname = "toolbox"
    toolbox.vm.network "private_network", ip: "192.168.7.100",
      virtualbox__intnet: "docker-lab-network"
    toolbox.vm.network "forwarded_port", guest: 8500, host: 8500
    toolbox.vm.provision "shell", path: "init-common.sh"
    toolbox.vm.provision "shell", path: "init-toolbox.sh"
  end

  config.vm.define "swarm01" do |swarm01|
    swarm01.vm.hostname = "swarm01"
    swarm01.vm.network "private_network", ip: "192.168.7.101",
      virtualbox__intnet: "docker-lab-network"
    swarm01.vm.provision "shell", path: "init-common.sh"
    swarm01.vm.provision "shell", path: "init-swarm01.sh"
  end

  config.vm.define "swarm02" do |swarm02|
    swarm02.vm.hostname = "swarm02"
    swarm02.vm.network "private_network", ip: "192.168.7.102",
      virtualbox__intnet: "docker-lab-network"
    swarm02.vm.provision "shell", path: "init-common.sh"
    swarm02.vm.provision "shell", path: "init-swarm02.sh"
  end

  config.vm.define "swarm03" do |swarm03|
    swarm03.vm.hostname = "swarm03"
    swarm03.vm.network "private_network", ip: "192.168.7.103",
      virtualbox__intnet: "docker-lab-network"
    swarm03.vm.provision "shell", path: "init-common.sh"
    swarm03.vm.provision "shell", path: "init-swarm03.sh"
  end

end
