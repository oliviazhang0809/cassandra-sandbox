# == Class: puppet
#
# This class installs and manages the Puppet client daemon.
#
class puppet (
  $server = $puppet::params::server,
  $ensure = $puppet::params::ensure,
  $box_type = $puppet::params::box_type,
  $puppet_hostname = $puppet::params::puppet_hostname,
  ) inherits puppet::params {

  class { 'puppet::install': } ->
  class { 'puppet::config': } ->
  class {'puppet::service': }
}
