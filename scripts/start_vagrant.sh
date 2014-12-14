#!/bin/sh

# install librarian-puppet to auto import modules
which librarian-puppet
if [ $? -ne 0 ]; then
  echo "Installing: gem librarian-puppet"
  sudo gem install librarian-puppet -v=1.3.2
fi
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

echo "Importing modules..."
librarian-puppet install --verbose

echo "Starting vagrant..."
vagrant up