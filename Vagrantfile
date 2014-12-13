# -*- mode: ruby -*-
# vi: set ft=ruby :

# Default settings:
VAGRANTFILE_API_VERSION = "2"
virtual_box = 'centos-64-x64-vbox4210'
environment = "dev"

# for virtualbox
virtual_box_domain = 'example.com'
seed_ip = '172.16.32.11'

puppet_nodes = [
  {:hostname => 'seed',   :role => 'seed',  :ip => '172.16.32.11', :autostart => true, :ram => 8192},
  {:hostname => 'child1', :role => 'child', :ip => '172.16.32.12', :autostart => true, :ram => 3072},
  {:hostname => 'child2', :role => 'child', :ip => '172.16.32.13', :autostart => true, :ram => 3072},
]

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  puppet_nodes.each do |node|
    config.vm.provider :virtualbox do |vb, newconfig|
      newconfig.vm.box = virtual_box
      newconfig.vm.box_url = "http://puppet-vagrant-boxes.puppetlabs.com/" + virtual_box + ".box"
      vb.gui = false
      vb.memory = node[:ram]
      vb.customize ["modifyvm", :id, "--cpuexecutioncap", "75"]
    end

    config.vm.define node[:hostname], autostart: node[:autostart] do |node_config|
      node_config.vm.hostname = node[:hostname] + '.' + virtual_box_domain
      node_config.vm.network :private_network, ip: node[:ip]
      node_config.ssh.shell = "bash -c 'BASH_ENV=/etc/profile exec bash'"
      node_config.vm.provision "shell", privileged: true, path: "scripts/setup.sh"

      node_config.vm.synced_folder ".", "/etc/puppet/", mount_options: ["dmode=777,fmode=666"]

      node_config.vm.provision :puppet do |puppet|
        puppet.hiera_config_path = "hiera.yaml"
        puppet.manifests_path = 'manifests'
        puppet.manifest_file  = "site.pp"
        puppet.module_path = ['modules', 'sites']
        puppet.facter = {
            "role" => node[:role],
            "environment" => environment,
            "seed_ip" => seed_ip,
          }
        puppet.options = "--verbose --debug --test"
      end

        # shut off the firewall
      node_config.vm.provision "shell", inline: "iptables -F"
      node_config.vm.provision "shell", inline: "service iptables save"
    end
  end
end
