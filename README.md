# Cassandra Vagrant Setup Instructions

## 1. Introduction

This program is a multi-VM Vagrant-based Puppet development environment used for creating and testing cassandra cluster, tested on both virtualbox and c3 (openstack).

* `puppet` - puppet master node
* `seed1` - cassandra seed node
* `seed2` - cassandra seed node
* `child` - cassandra client node

You can simply define your own cluster nodes by setting up parameters under `Default Settings` in `Vagrantfile`.
For example, you can set `hostname`, `role` (it's a seed node or child node) of a node in `puppet_nodes`. For virtualbox instance, you can also specify ip address, ram, etc.

The default setup is a three nodes cluster with two seed nodes managed by one puppetmaster node with puppetDB installed. The puppetmaster will update the configurations of client nodes every 30 minutes. 

## 2. Initial Setup
### 2.1 Default Value Setup

Please check `Vagrantfile`, the `Default Setting` session to see if variables are set as you expected.

### 2.2 Environment Installation

To bring up c3 instances, please finish steps in [INSTALLATION](https://github.paypal.com/Stingray/dev-environment/blob/develop/INSTALLATION.md) to have correct environment setup.

**Note**: for this project, your keypair should be named as `cassandra` instead of `vagrant`.

### 2.3 Fix bug in c3 and vagrant-openstack-plugin

##### 2.3.1 ssl handshake problem

In ssl_socket.rb (mine is under /Users/tzhang1/.vagrant.d/gems/gems/excon-0.42.1/lib/excon/ssl_socket.rb), add

```
ssl_context.ssl_version = 'TLSv1' 
```
in line 28 (after where `ssl_context.ssl_version` is defined.)

##### 2.3.2 rsync not installed problem

This is a well-known bug for vagrant-openstack-plugin that it assumes box that is being used has `rsync` installed. What you need to do is, in `sync_folders.rb` (mine is in `/Users/tzhang1/.vagrant.d/gems/gems/vagrant-openstack-plugin-0.11.1/lib/vagrant-openstack-plugin/action/sync_folders.rb`), add
```
install_rsync = "yum -y install rsync"
env[:machine].communicate.sudo(install_rsync)
```
Since I'm using centOS box, so I use `yum` to install. The basic idea is to install `rsync` before `command` get executed.

### 2.4 Correct Activation Order

Please activate puppetmaster before client nodes.

## 3. Bring up your machines

### 1. One time setup
You need to install some dependencies (gems, plugins, etc) before starting the program the first time. Besides [vagrant](https://docs.vagrantup.com/v2/installation/), you can get everything setup by running
```
    $ scripts/bootstrap.sh
```
After which, you can use 
```
    $ scripts/start_vagrant.sh
``` 
to spin up virtualboxs or c3 nodes by answering the prompt question box on provider. 
Alternatively, if you have already had `PROVIDER` as environmental variable setup, you can just run 
```
    $ vagrant up 
```
to boost virtual machines
```
    $ vagrant up --provider=openstack puppet
```
to bring up c3 instances.

Since puppet master should be up and running before client nodes, spin up master specifically before other nodes is recommended. 

Also, the first time running the bootstrap script, you will have some necessary gems installed if they were not there. For example, gem `puppet-lint` and `rake`. Once have them installed, you can do 
```
    $ rake lint
```
to check the Puppet style. And do 
```
    $ puppet-lint --fix /path/to/vagrant
```
to automatically fix style problems ^_^.

## 4. Check Your Handiwork 
You can easily log in to your box by
```
    $ vagrant ssh $box_name
```
The client boxes are sync with master node and will periodically update configurations. If you want to do it manually, you can change to super user and run 
```
    $ puppet agent -t
```
Last but not least, feel free to use your familiar command such as `nodetool status` to play around with your new cassandra cluster. Have fun! :)

