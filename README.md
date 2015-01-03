# Cassandra Vagrant Setup Instructions

## 1. Introduction

This program is a multi-VM Vagrant-based Puppet development environment used for creating and testing cassandra cluster, tested on both virtualbox and c3 (openstack).

## 2. Initial Setup
### 2.1 Default Value Setup
The default setup is a three nodes cluster with two seed nodes and one child node managed by one master node with puppetDB installed. 
* `puppet` - puppet master node
* `seed1`, `seed2` - cassandra seed node
* `child` - cassandra client node

In `Vagrantfile` under `Default Settings` session, we have default parameters setup as following.
#####`provider`
`v` for  virtualbox, `o` for c3 instance.
#####`cluster_name`
Name of your cluster. 
#####`puppet_nodes`
Initial settings of all nodes including `hostname`, `role`, `ip`, `autostart` and `ram`.
#####`puppet_hostname`
The hostname of puppetmaster, **which needs to be changed if you are boosting openstack instance** (see 3.3 After Spin Up Puppetmaster [c3 instance]). 

By default, it's set as `puppet.example.com`. 

For further information, please check `Vagrantfile`, the `Default Setting` session.

### 2.2 Environment Installation
To bring up c3 instances, please finish steps in [INSTALLATION](https://github.paypal.com/Stingray/dev-environment/blob/develop/INSTALLATION.md) to have correct environment setup.

**Note**: for this project, your keypair should be named as `cassandra` instead of `vagrant`.

### 2.3 Correct Activation Order

`puppet` (the master) node should be brought up before all other nodes.

### 2.4 Fix bug in c3 and vagrant-openstack-plugin
If you encountered the following problems when boosting c3 instances.
##### 2.4.1 - ssl handshake problem
In ssl_socket.rb (mine is under `/Users/tzhang1/.vagrant.d/gems/gems/excon-0.42.1/lib/excon/ssl_socket.rb`), add
```
ssl_context.ssl_version = 'TLSv1' 
```
in line 28 (after where `ssl_context.ssl_version` is defined.)

##### 2.4.2 - rsync not installed problem
This is a well-known bug for vagrant-openstack-plugin.
In sync_folders.rb (mine is under `/Users/tzhang1/.vagrant.d/gems/gems/vagrant-openstack-plugin-0.11.1/lib/vagrant-openstack-plugin/action/sync_folders.rb`), add
```
install_rsync = "yum -y install rsync"
env[:machine].communicate.sudo(install_rsync)
```
Here I'm using centOS box, so I use `yum` to install. The basic idea is to install `rsync` before `command` get executed.

## 3. Bring up your machines

### 3.1 One time setup
You need to install some dependencies (gems, plugins, etc) before starting the program the first time. Besides [vagrant](https://docs.vagrantup.com/v2/installation/), you can get everything setup by running
```
    $ scripts/bootstrap.sh
```
### 3.2 Every time you spin up your machine

```
    $ scripts/start_vagrant.sh
``` 
This script will help you bring up all machines. You will need to answer questions on which provider (virtualbox or c3 instances) should be used for new machine. 

**Alternatively**, if you have already set `PROVIDER` as environment variable (v: virtualbox, o: openstack), you can just run vagrant command:

For virtual box:
```
    $ vagrant up 
```
For c3 instance:
```
    $ vagrant up --provider=openstack puppet
```
Since openstack provider will NOT bring up machines in order, I strongly recommend 
### 3.3 After Spin Up Puppetmaster

**By default**, the program will spin up puppetmaster without activating all other nodes. 

**[ Virtualbox ]** 

Since we know the `fqdn` of puppet master node (by default - `puppet.example.com`), you can spin up other boxes just by
```
    $ vagrant up 
```
**[ c3 instance ]** Please check the fqdn of your machine on c3 and change the name of `puppet_hostname` in `Vagrantfile` before
```
    $ vagrant up --provider=openstack
```
### 3.4 Handy gems 
The `bootstrap.sh` will install some necessary gems if they were not there such as `puppet-lint` and `rake`. Once have them installed, you can do 
```
    $ rake lint
```
to check the Puppet style. And do 
```
    $ puppet-lint --fix /path/to/vagrant
```
to automatically fix style problems.

## 4. Check Your Handiwork 
After machines are up and running, you can easily log into your box by
```
    $ vagrant ssh $box_name
```
The client nodes are synced with master and will periodically update configurations every 30 minutes if there is any inconsistency. If you want to do it manually, you can always change to super user and run 
```
    $ puppet agent -t
```
Last but not least, feel free to use your familiar command such as `nodetool status` to play around with your new cassandra cluster. Have fun! :)
