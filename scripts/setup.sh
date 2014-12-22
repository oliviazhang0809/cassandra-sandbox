# install puppet gem files
gem install -q -v=3.7.3 --no-rdoc --no-ri puppet
gem install -q -v=2.2.8 --no-rdoc --no-ri CFPropertyList
gem install -q -v=1.1.1 --no-rdoc --no-ri hiera-file
gem install -q -v=1.0.1 --no-rdoc --no-ri deep_merge

puppet agent --enable

# set time in box
#ln -sf /usr/share/zoneinfo/America/Los_Angeles /etc/localtime
