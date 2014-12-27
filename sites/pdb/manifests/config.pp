# == Class: pdb::config
#
# manager puppetdb customized setting
#
class pdb::config (
  $puppet_hostname = hiera('puppet_hostname'),
  $ssl_dir = hiera('ssl_dir')
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

  # puppetdb class
class { 'puppetdb::server':
  ssl_set_cert_paths => true,
  ssl_deploy_certs   => true,
  ssl_key            => $ssl_key_content,
  ssl_cert           => $ssl_cert_content,
  ssl_ca_cert        => $ssl_ca_cert_content,
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
