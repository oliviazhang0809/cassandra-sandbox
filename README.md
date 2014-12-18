# Cassandra Vagrant Setup Instructions

## Introduction

This program is a multi-VM Vagrant-based Puppet development environment used for creating and testing cassandra cluster.

* `seed` - cassandra seed node
* `child1` - cassandra client node
* `child2` - cassandra client node

You can add more nodes by duplicating the `seed` or `child` node -- only `hostname` and `ip` need to be changed.
Current setup is a three nodes cluster with one seed node. You can easily add more seed nodes by changing the value of `seed_ip` in `Vagrantfile`. This is the value to be passed into `cassandra.yaml` file to configure the cluster.

## Initial Setup
### Default Value Setup

Please check settings in `Vagrantfile`, to see if the following variables are set as you expected.

`environment`: "dev" -- development environment

Running with virtualbox, these machines are using following IP addresses and ports:

* _seed_ - `172.16.32.11`
* _child1_ - `172.16.32.12`
* _child2_ - `172.16.32.13`

### Environment Installation

To bring up c3 instances, please finish steps in [INSTALLATION](https://github.paypal.com/Stingray/dev-environment/blob/develop/INSTALLATION.md) to have correct environment setup.
Note: for this project, your keypair should be named as `cassandra` instead of `vagrant`.

### Correct Activation Order

* cassandra seed node must be activated before child nodes (child1, child2).

## Bring up your machines

You can easily bring up your machine by
```
    $ scripts/start_vagrant.sh
```

In the prompt, you can specify the `provider` of your machines: v -- virtualbox, o -- openstack.

If you are running with c3 instances, you need to set up `seed_ip` in `Vagrantfile` after you have seed node up so that the client nodes can have a recognizable ip address to join the cluster. Currently there is no way to automate this process since I'm not sure how to set up fixed IP address for c3 instance.

## Check Your Handiwork 
You can easily log in to your box by
```
    $ vagrant ssh $box_name
```
And feel free to use your familiar command such as `nodetool status` to play around with your new cassandra cluster. :)