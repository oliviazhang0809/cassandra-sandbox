# Class: passenger
#
# This class installs apache passenger and its dependencies
# It will stop puppetmaster service (that runs on webrick) and make master node running on apache instead
#
class passenger {

  require puppet::master

  class { 'passenger::install': } ->
  class { 'passenger::compile': } ->
  class { 'passenger::config': } ->
  class { 'passenger::service': }

}
