# Class: cassandra
#
class cassandra {

  require javaimpl

  class {'cassandra::repo': } ->
  class {'cassandra::install': } ->
  class {'cassandra::config': } ->
  class {'cassandra::service': }
}
