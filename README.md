# Cassandra Vagrant Setup Instructions

## 1. Introduction

This program is a multi-VM Vagrant-based Puppet development environment used for creating and testing cassandra cluster, tested on both virtualbox and c3 (openstack).

## 2. Initial Setup
### 2.1 Default Value Setup

The default setup is a three nodes cluster with two seed nodes managed by one master node with puppetDB installed. 
* `puppet` - puppet master node
* `seed1` - cassandra seed node
* `seed2` - cassandra seed node
* `child` - cassandra client node

#####`provider`
`v` for  virtualbox, `o` for c3 instance.
#####`cluster_name`
Name of your cluster. 
#####`puppet_nodes`
Initial settings of all nodes including `hostname`, `role`, `ip`, `autostart` and `ram`.
#####`puppet_hostname`
The hostname of puppetmaster. **This is importance because puppet agent is using it to talk to master node**. By default, it's set as `puppet.example.com`. 

For further information, please check `Vagrantfile`, the `Default Setting` session.

### 2.2 Environment Installation
To bring up c3 instances, please finish steps in [INSTALLATION](https://github.paypal.com/Stingray/dev-environment/blob/develop/INSTALLATION.md) to have correct environment setup.

**Note**: for this project, your keypair should be named as `cassandra` instead of `vagrant`.

### 2.3 Correct Activation Order

`puppet` node should be spinned up before all other nodes.

## 3. Bring up your machines

### 3.1 One time setup
You need to install some dependencies (gems, plugins, etc) before starting the program the first time. Besides [vagrant](https://docs.vagrantup.com/v2/installation/), you can get everything setup by running
```
    $ scripts/bootstrap.sh
```
### 3.2 Every time you spin up your machine
Please use 
```
    $ scripts/start_vagrant.sh
``` 
And then answer prompt questions on provider to spin up virtualboxs or c3 instances. 

**Alternatively**, if you have already set `PROVIDER` as environment variable (v: virtualbox, o: openstack), you can just run 
```
    $ vagrant up 
```
to boost virtual machines, or
```
    $ vagrant up --provider=openstack puppet
```
to bring up c3 instances.

### 3.3 After Spin Up Puppetmaster

**By default**, the program will spin up puppetmaster without activating all other nodes. 
To fully bring up all machines.
Please ssh into your puppet master.
```
    $ vagrant ssh puppet
```
And then `sudo -s` to become a super user and have a configuration run on master node.
```
    $ puppet agent -t
```
After the process get finished, `exit` the box. 

**[ Virtualbox ]** 
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
After machines are up and running, you can easily log in to your box by
```
    $ vagrant ssh $box_name
```
The client nodes are synced with master and will periodically update configurations every 30 minutes if there is any inconsistency. If you want to do it manually, you can always change to super user and run 
```
    $ puppet agent -t
```
Last but not least, feel free to use your familiar command such as `nodetool status` to play around with your new cassandra cluster. Have fun! :)
