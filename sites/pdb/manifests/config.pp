# == Class: pdb::config
#
# manager puppetdb customized setting
#
class pdb::config (
  $puppet_hostname = $pdb::puppet_hostname,
  $ssl_dir = hiera('ssl_dir'),
  $puppetdb_node_ttl = hiera('puppetdb_node_ttl'),
  $puppetdb_version = hiera('puppetdb_version')
  ){

  if file_exists("${ssl_dir}/private_keys/${puppet_hostname}.pem") == 1 {
    $ssl_key_content = file("${ssl_dir}/private_keys/${puppet_hostname}.pem")
  } else {
    $ssl_key_content = undef
  }

  if file_exists("${ssl_dir}/certs/${puppet_hostname}.pem") == 1 {
    $ssl_cert_content = file("${ssl_dir}/certs/${puppet_hostname}.pem")
  } else {
    $ssl_cert_content = undef
  }

  if file_exists("${ssl_dir}/certs/ca.pem") == 1 {
    $ssl_ca_cert_content = file("${ssl_dir}/certs/ca.pem")
  } else {
    $ssl_ca_cert_content = undef
  }

  class { 'puppetdb':
    listen_address    => '0.0.0.0',
    ssl_listen_address => '0.0.0.0',
    puppetdb_version  => $puppetdb_version,
    node_ttl          => $puppetdb_node_ttl,
    ssl_key                 => $ssl_key_content,
    ssl_cert                => $ssl_cert_content,
    ssl_ca_cert             => $ssl_ca_cert_content,
    database_listen_address => '*',
  }
}
