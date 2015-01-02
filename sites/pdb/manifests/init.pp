# Class: pdb
#
class pdb (
  $puppet_hostname = hiera('puppet_hostname')
  ){
  require passenger
  require passenger::service

  class {'pdb::config': } ->
  class {'pdb::connect': }
}
