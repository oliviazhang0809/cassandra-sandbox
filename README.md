# Cassandra Vagrant Setup Instructions

## 1. Introduction

This program is a multi-VM Vagrant-based Puppet development environment used for creating and testing cassandra cluster, tested on both virtualbox and ebay c3 instance (built on top of openstack).

## 2. Initial Setup
### 2.1 Roles and Responsibilities
The default setup is a three nodes cluster with two seed nodes and one child node managed by puppet master node. 
* `puppet` - puppet master node
* `seed1`, `seed2` - cassandra seed node
* `child` - cassandra client node

### 2.2 Default Instance Setup
##### 2.2.1 - Instance Setting
**- Virtual box setup**

| hostname  | fqdn  | role  | ip  | autostart  | ram  |
|------|------|------|------|------|------|
| puppet  | puppet.example.com | master  | 172.16.32.10  | true  | 2048  |
| seed1  | seed1.example.com |seed  | 172.16.32.11  | false  | 2048  |
| seed2  | seed2.example.com | seed  | 172.16.32.12  | false  |  2048 |
| child  | child.example.com |child  | 172.16.32.13  | false  | 2048  |

**- c3 box setup**

| hostname  | role  | autostart  | ram  |
|------|------|------|------|
| puppet  | master  | true  | 6G  |
| seed1  | seed  | false  | 6G  |
| seed2  | seed  | false  |  6G |
| child  | child  | false  | 6G  |
**Note:** Virtualbox is using `centos-64-x64-vbox4210` image provided by [puppetlabs](http://puppet-vagrant-boxes.puppetlabs.com/).
C3 instance is using `emi-centos-6.4-x86_64` image located in [Stingray Vagrant repos](http://stingray-vagrant.stratus.dev.ebay.com/vagrant/boxes/openstack/).
##### 2.2.2 - Other Settings
In `Vagrantfile` under `Default Settings` session, we have default parameters setup as following.
#####`provider`
`v` for  virtualbox, `o` for c3 instance. When running the `start_vagrant.sh` user will be prompted to choose the provider. 
#####`cluster_name`
Name of your cassandra cluster. Default as `DevCluster`.
#####`puppet_nodes`
Initial settings of all nodes including `hostname`, `role`, `ip`, `autostart` and `ram`.
#####`puppet_hostname`
The hostname of puppetmaster, **which needs to be changed if you are boosting c3 instance** (see *3.3 After Spin Up Puppetmaster [c3 instance]*). 

By default, it's set as `puppet.example.com`. 

For further information, please check `Vagrantfile`, the `Default Setting` session.

### 2.2 Environment Installation
To bring up c3 instances, please finish steps in [INSTALLATION](https://github.paypal.com/Stingray/dev-environment/blob/develop/INSTALLATION.md) to have correct environment setup.

**Note**: for this project, your keypair should be named as `cassandra` instead of `vagrant`.

### 2.3 Correct Vagrant Up Order

By default, puppet master will be brought up first by vagrant. But if you want to bring up individual machine, please follow the order of puppet master -> seed -> child.

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

## 3. Steps to bring up your machines

Please go to `duke-serv/vagrant` and follow the instructions.

### 3.1 One time setup
You need to install some dependencies (gems, plugins, etc) before starting the program the first time. Besides [vagrant](https://docs.vagrantup.com/v2/installation/), you can get everything setup by running
```
    $ scripts/bootstrap.sh
```
### 3.2 Every time you spin up your machine

```
    $ . scripts/start_vagrant.sh (This dot is important.)
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
Since openstack provider will NOT bring up machines in order, I strongly recommend you follow the order specified in **session 2.3**.
### 3.3 After Spin Up Puppetmaster
**By default**, the program will spin up puppetmaster without activating all other nodes. 

**[ Virtualbox ]** 

Since we know the `fqdn` of puppet master node (by default - `puppet.example.com`), you can spin up other boxes just by
```
    $ vagrant up 
```
**[ c3 instance ]** 

Please check the fqdn of your machine on c3 and export `puppet_hostname` as environment variable.
```
    $ export PUPPET_HOSTNAME=$YOUR_MASTER_FQDN
```

and then you can `vagrant up` the other boxes.

```
    $ vagrant up --provider=openstack
```
**Note** Boxes are not brought up in c3 in correct order if you just `vagrant up`. You may want to write a simple shell script 

E.G.
`to_be_remove.sh` with content of:
```
    vagrant up --provider=openstack seed1
    vagrant up --provider=openstack seed2
    vagrant up --provider=openstack child
```
And run it to ensure the order is correct.

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
## 5. Add More Nodes
You can easily add more nodes by adding node information in `puppet_nodes` with unique `hostname` and `ip`, besides specified `role`.