# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.
   
  if Vagrant.has_plugin?("vagrant-cachier")
    # Configure cached packages to be shared between instances of the same base box.
    # More info on http://fgrehm.viewdocs.io/vagrant-cachier/usage
    config.cache.scope = :box
  end

  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "ubuntu/trusty64"

  config.vm.provider "virtualbox" do |vb|
     vb.customize ["modifyvm", :id, "--memory", "512"]
     vb.customize ["modifyvm", :id, "--cpus", "1"]
  end

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.

  config.vm.define "web-box1" do |box|
    box.vm.network "private_network", ip: "192.168.33.68"
    box.vm.hostname = "web-box1"
    box.vm.provision "shell", path: "web.sh"
  end

  config.vm.define "web-box2" do |box|
    box.vm.network "private_network", ip: "192.168.33.69"
    box.vm.hostname = "web-box2"
    box.vm.provision "shell", path: "web.sh"
  end
   
  config.vm.define "lb-box1" do |box|
    box.vm.network "private_network", ip: "192.168.33.80"
    box.vm.hostname = "lb-box1"
    box.vm.provision "shell", path: "lb.sh", args: "1"
  end

  config.vm.define "lb-box2" do |box|
    box.vm.network "private_network", ip: "192.168.33.81"
    box.vm.hostname = "lb-box2"
    box.vm.provision "shell", path: "lb.sh", args: "2"
  end

end

