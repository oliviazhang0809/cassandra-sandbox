#!/bin/sh
echo "Please enter your provider, v: virtualbox, o: openstack: "
read PROVIDER
export PROVIDER=$PROVIDER

echo "Starting vagrant..."
# bring up machines based on provider
if [ "$PROVIDER" = 'o' ]; then
  vagrant up --provider=openstack
else
  vagrant up
fi
