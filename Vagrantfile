# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'vagrant-openstack-plugin'

################## Default settings #######################
VAGRANTFILE_API_VERSION = "2"
provider = ENV['PROVIDER']
environment = "dev"

# for virtualbox
virtual_box_domain = 'example.com'
virtual_box = 'centos-64-x64-vbox4210'
virtualbox_seed_ip = "172.16.32.11,172.16.32.12"

# for c3 instance
openstack_box = 'emi-centos-6.4-x86_64'
######################################################

# MUST CHANGE EACH TIME
puppet_hostname = "puppet.example.com" # change after puppet master is up
seed_ip = "x" # change after seed is up

puppet_nodes = [
 {:hostname => 'puppet',   :role => 'master',  :ip => '172.16.32.10', :autostart => true, :ram => 2048},
 {:hostname => 'seed',   :role => 'seed',  :ip => '172.16.32.11', :autostart => true, :ram => 2048},
 {:hostname => 'child1', :role => 'child', :ip => '172.16.32.12', :autostart => true, :ram => 2048},
 {:hostname => 'child2', :role => 'child', :ip => '172.16.32.13', :autostart => true, :ram => 2048},
]

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
 puppet_nodes.each do |node|

   config.vm.provider :virtualbox do |vb, newconfig|
     newconfig.vm.box = virtual_box
     newconfig.vm.box_url = "http://puppet-vagrant-boxes.puppetlabs.com/" + virtual_box + ".box"
     vb.gui = false
     vb.memory = node[:ram]
     vb.customize ["modifyvm", :id, "--cpuexecutioncap", "50"]
   end

   config.vm.provider :openstack do |os, newconfig|
       newconfig.vm.box = openstack_box
       newconfig.vm.box_url = "http://stingray-vagrant.stratus.dev.ebay.com/vagrant/boxes/openstack/" + openstack_box + ".box"
       newconfig.ssh.private_key_path = "~/.ssh/cassandra.pem"
       os.keypair_name = "cassandra"
       os.flavor = "medium"
   end

   config.vm.define node[:hostname], autostart: node[:autostart] do |node_config|

     # only for virtualbox, hostname and ip need to be setup
     if provider == "v"
       seed_ip = "172.16.32.11,172.16.32.12"
       node_config.vm.hostname = node[:hostname] + '.' + virtual_box_domain
       node_config.vm.network :private_network, ip: node[:ip]
       # setup /etc/hosts for private network
       puppet_nodes.each do |n|
         if node[:hostname] != n[:hostname]
           node_config.vm.provision "shell" do |s|
             s.inline = "echo $1 $2 $3 >> /etc/hosts"
             s.args = [ n[:ip], n[:hostname] + "." + virtual_box_domain, n[:hostname] ]
           end
         end
       end
     end

     node_config.ssh.shell = "bash -c 'BASH_ENV=/etc/profile exec bash'"

     node_config.vm.provision "shell", privileged: true, path: "scripts/setup.sh", args: [ node[:role], environment, puppet_hostname, seed_ip ]

     if node[:role] == "master"
       node_config.vm.synced_folder ".", "/var/www/puppet/", mount_options: ["dmode=777,fmode=666"]
       node_config.vm.provision "shell", inline: "rm -R /etc/puppet && cp -rf /var/www/puppet /etc"
       node_config.vm.provision :puppet do |puppet|
         puppet.hiera_config_path = "hiera.yaml"
         puppet.manifests_path = 'manifests'
         puppet.manifest_file  = "site.pp"
         puppet.module_path = ['modules', 'sites']
         puppet.facter = {
             "role" => node[:role],
             "environment" => environment,
             "seed_ip" => seed_ip,
             "puppet_hostname" => puppet_hostname,
           }
         puppet.options = "--verbose --debug --test"
       end
     else
       node_config.vm.provision "puppet_server" do |puppet|
         puppet.puppet_server = puppet_hostname
         puppet.options = "--verbose --debug --test --waitforcert 60"
       end
     end

     # shut off the firewall
     node_config.vm.provision "shell", inline: "iptables -F"
     node_config.vm.provision "shell", inline: "service iptables save"
   end
 end
end