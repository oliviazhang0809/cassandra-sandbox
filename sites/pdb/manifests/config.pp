# == Class: pdb::config
#
# manager puppetdb customized setting
#
class pdb::config (
  $puppet_hostname = hiera('puppet_hostname'),
  $ssl_dir = hiera('ssl_dir')
  ){

  # puppetdb class
class { 'puppetdb::server':
  ssl_set_cert_paths => true,
  ssl_deploy_certs   => true,
  ssl_key            => file("${ssl_dir}/private_keys/${puppet_hostname}.pem"),
  ssl_cert           => file("${ssl_dir}/certs/${puppet_hostname}.pem"),
  ssl_ca_cert        => file("${ssl_dir}/certs/ca.pem"),
  }
class { 'puppetdb::database::postgresql':
    listen_addresses => '*',
  }

  firewall { '5432 postgresql':
    action => 'accept',
    proto  => 'tcp',
    dport  => '5432',
  } ->

  firewall { '8081 puppetdb':
    action => 'accept',
    proto  => 'tcp',
    dport  => '8081',
  }
}
