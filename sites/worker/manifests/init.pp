# Class: worker
#
# connect puppet master to puppetdb
#
class worker (
  $puppet_hostname = hiera('puppet_hostname')
  ){

  require pdb
  
  class { 'puppetdb::master::config':
    puppetdb_server     => $puppet_hostname,
    puppet_service_name => 'httpd',
  }
}
