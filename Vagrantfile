# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  config.vm.define "dns" do |dns|
    dns.vm.box = "centos/7"
    dns.vm.network "private_network", ip: "192.192.10.2"
    dns.vm.hostname = "named.lab.com"
    dns.vm.provider :virtualbox do |vb|
      vb.customize ["modifyvm", :id, "--memory", "2048" ]
      vb.customize ["modifyvm", :id, "--cpus", "2" ]
    end

    dns.vm.provision "shell", path: 'config/setup_dns.sh', privileged: true
  end
  config.vm.define "node1" do |node1|
    node1.vm.box = "centos/7"
    node1.vm.network "private_network", ip: "192.192.10.20"
    node1.vm.hostname = "node-1.lab.com"
    node1.vm.provider :virtualbox do |vb|
      vb.customize ["modifyvm", :id, "--memory", "2048" ]
      vb.customize ["modifyvm", :id, "--cpus", "2" ]
    end
    # node1.vm.provision "shell", path: 'config/setup_db_node.sh', privileged: true
  end
  config.vm.define "node2" do |node2|
    node2.vm.box = "centos/7"
    node2.vm.network "private_network", ip: "192.192.10.30"
    node2.vm.hostname = "node-2.lab.com"
    node2.vm.provider :virtualbox do |vb|
      vb.customize ["modifyvm", :id, "--memory", "2048" ]
      vb.customize ["modifyvm", :id, "--cpus", "2" ]
    end
    # node2.vm.provision "shell", path: 'config/setup_db_node.sh', privileged: true
  end
  config.vm.synced_folder "config/", "/vagrant/config"
end
