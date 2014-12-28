# install puppet gem files
gem install -q -v=3.7.3 --no-rdoc --no-ri puppet
gem install -q -v=2.2.8 --no-rdoc --no-ri CFPropertyList
gem install -q -v=1.1.1 --no-rdoc --no-ri hiera-file
gem install -q -v=1.0.1 --no-rdoc --no-ri deep_merge

puppet agent --enable

# add custom facts
mkdir -p /etc/facter/facts.d
echo role=$1 > /etc/facter/facts.d/role.txt 
echo environment=$2 > /etc/facter/facts.d/environment.txt 
echo puppet_hostname=$3 > /etc/facter/facts.d/puppet_hostname.txt 

# installl puppet repos
rpm -ivh http://yum.puppetlabs.com/el/6/products/x86_64/puppetlabs-release-6-6.noarch.rpm
