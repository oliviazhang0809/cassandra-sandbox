#!/bin/sh
echo "Please enter your provider, v: virtualbox, o: openstack: "
read PROVIDER
export PROVIDER=$PROVIDER

echo "Importing modules..."
librarian-puppet install --verbose
mv modules/puppetlabs-ntp modules/ntp

echo "Setting default PUPPET_HOSTNAME..."
export PUPPET_HOSTNAME="puppet.example.com"
echo "Starting vagrant..."
# bring up machines based on provider
if [ "$PROVIDER" = 'o' ]; then
  vagrant up --provider=openstack
else
  vagrant up
fi
