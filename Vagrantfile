# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.

BOX_IMAGE = "centos/7"
NODE_COUNT = 2

Vagrant.configure("2") do |config|
  # config.vm.synced_folder "config/" "/vagrant/config"
  config.vm.define "dns" do |dns|
    dns.vm.box = BOX_IMAGE
    dns.vm.network "private_network", ip: "192.192.10.2"
    dns.vm.hostname = "named.lab.com"
    dns.vm.provider :virtualbox do |vb|
      vb.customize ["modifyvm", :id, "--memory", "2048" ]
      vb.customize ["modifyvm", :id, "--cpus", "2" ]
    end

    dns.vm.provision "shell", path: 'test.sh'
    dns.vm.provision "shell", path: './config/setup_dns.sh'
  end

  (1..NODE_COUNT).each do |i|
    config.vm.define "node#{i}" do |subconfig|
      subconfig.vm.box = "centos/7"
      addr = 10+10*i
      subconfig.vm.network "private_network", ip: "192.192.10.#{addr}"
      subconfig.vm.hostname = "node-#{i}.lab.com"
      subconfig.vm.provider :virtualbox do |vb|
        vb.customize ["modifyvm", :id, "--memory", "2048" ]
        vb.customize ["modifyvm", :id, "--cpus", "2" ]
      end
      # subconfig.vm.provision "shell", path: 'test.sh'
      subconfig.vm.provision "shell", path: './config/setup_db_node.sh'
    end
  end
  config.vm.synced_folder "config/", "/vagrant/config"
end
