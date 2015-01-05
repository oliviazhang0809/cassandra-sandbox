#!/bin/sh

# install puppet gem
which puppet
if [ $? -ne 0 ]; then
  echo "Installing: gem puppet"
  sudo gem install -q -v=3.7.3 puppet
fi

# install librarian-puppet to auto import modules
which librarian-puppet
if [ $? -ne 0 ]; then
  echo "Installing: gem librarian-puppet"
  sudo gem install -q -v=1.3.2 librarian-puppet
fi

# install vagrant-openstack-plugin
vagrant plugin list | grep vagrant-openstack-plugin
if [ $? -ne 0 ]; then
  echo "Installing: vagrant plugin: vagrant-openstack-plugin and dependencies"
  vagrant plugin install vagrant-openstack-plugin --plugin-version 0.11.1
fi

echo "Importing modules..."
librarian-puppet install --verbose

which puppet-lint
if [ $? -ne 0 ]; then
  echo "Installing: gem puppet-lint and rake"
  sudo gem install -q -v=1.1.0 puppet-lint
fi
