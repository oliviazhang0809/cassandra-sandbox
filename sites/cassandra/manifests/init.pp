# Class: cassandra
#
class cassandra {

  class {'cassandra::repo': } ->
  class {'cassandra::install': } ->
  class {'cassandra::config': } ->
  class {'cassandra::service': }
}