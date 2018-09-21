# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/xenial64"
  config.vm.boot_timeout = 60
  config.vm.provider "virtualbox" do |vb|
    vb.gui = false
  end
  config.vm.provision "shell", inline: "apt-get update"

  config.vm.define "k8sMaster" do |k8sMaster|
    k8sMaster.vm.host_name = "k8sMaster"
    k8sMaster.vm.provider "virtualbox" do |vb|
      vb.memory = 1024
      vb.cpus = 1
    end
    k8sMaster.vm.network "private_network", ip: "192.168.32.11"
#    k8sMaster.vm.provision "ansible" do |ansible|
#      ansible.playbook = "k8sMaster.yml"
#    end
  end

  config.vm.define "k8sSlave" do |k8sSlave|
    k8sSlave.vm.host_name = "k8sSlave"
    k8sSlave.vm.provider "virtualbox" do |vb|
      vb.memory = 512
      vb.cpus = 1
    end
    k8sSlave.vm.network "private_network", ip: "192.168.32.12"
    k8sSlave.vm.network "forwarded_port", guest: 30000, host: 30000, auto_correct: true
    k8sSlave.vm.network "forwarded_port", guest: 32000, host: 32000, auto_correct: true
  end

  config.vm.define "gluster" do |gluster|
    gluster.vm.host_name = "gluster"
    gluster.vm.provider "virtualbox" do |vb|
      vb.memory = 512
      vb.cpus = 1
    end
    gluster.vm.network "private_network", ip: "192.168.32.10"

  end
end
