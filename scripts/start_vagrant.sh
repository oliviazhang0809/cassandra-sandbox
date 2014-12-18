#!/bin/sh

# install puppet gem
which puppet
if [ $? -ne 0 ]; then
  echo "Installing: gem puppet"
  sudo gem install puppet -v=3.7.2
fi

gem list | grep CFPropertyList
if [ $? -ne 0 ]; then
  echo "Installing: gem CFPropertyList"
  sudo gem install -v=2.2.8 --no-rdoc --no-ri CFPropertyList
fi

# install librarian-puppet to auto import modules
which librarian-puppet
if [ $? -ne 0 ]; then
  echo "Installing: gem librarian-puppet"
  sudo gem install librarian-puppet -v=1.3.2
fi

echo "Importing modules..."
librarian-puppet install --verbose

# install vagrant-openstack-plugin
vagrant plugin list | grep vagrant-openstack-plugin
if [ $? -ne 0 ]; then
  echo "Installing: vagrant plugin: vagrant-openstack-plugin and dependencies"
  sudo gem install fission -v '0.5.0'
  # need to install 0.8.0 to make it work
  sudo gem install -q -v=0.8.0 --no-rdoc --no-ri vagrant-openstack-plugin
  sudo vagrant plugin install vagrant-openstack-plugin --plugin-version 0.8.0
fi

echo "Please enter your provider, v: virtualbox, o: openstack: "
read PROVIDER
export PROVIDER=$PROVIDER

echo "Starting vagrant..."
# bring up machines based on provider
if [ "$PROVIDER" = 'o' ]; then
  vagrant up --provider=openstack seed
else
  vagrant up
fi