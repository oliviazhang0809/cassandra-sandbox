# == Class: puppet::params
# DO NOT CALL DIRECTLY
class puppet::params {
    $ensure  = hiera('puppet_version', '3.7.3-1.el6')
    $box_type = hiera('box_type', 'virtualbox')

    $server = $box_type ? {
    'virtualbox' => 'puppet.example.com',
    'openstack' => $::fqdn ? {
      /^(puppet)-\d.*/ => $::fqdn,
      default => $::puppet_hostname,
    }
  }
}
