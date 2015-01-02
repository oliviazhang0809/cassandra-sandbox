# Class: pdb::connect
#
# connect puppet master to puppetdb
#
class pdb::connect (
  $puppet_hostname = $pdb::puppet_hostname,
  ){

  class { 'puppetdb::master::config':
    puppetdb_server     => $puppet_hostname,
    puppet_service_name => 'httpd',
    strict_validation   => false,
  }
}
