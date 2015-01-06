# Class: javaimpl
#
# This class implements jdk_oracle module
#
class javaimpl(
  $java_version = hiera('java_version'),
  $jdk_version = hiera('jdk_version')
  ){

  class { 'jdk_oracle':
      version => $java_version,
  } ->
  javaimpl::set { 'set_java':
    value => 'java',
  } ->
  javaimpl::set { 'set_javac':
    value => 'javac',
  } ->
  javaimpl::set { 'set_jar':
    value => 'jar',
  }
}
