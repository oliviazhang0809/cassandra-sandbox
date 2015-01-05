# Class: javaimpl
#
# This class implements jdk_oracle module
#
class javaimpl(
  $java_version = hiera('java_version'),
  $jdk_version = hiera('jdk_version')
  ) {

  # set_up::value { 'value': }
  define set_up::value (
    $value = '',
  ){
    exec { "set_up_${value}":
      command => "sudo alternatives --install /usr/bin/${value} ${value} /opt/jdk${jdk_version}/bin/${value} 1",
      unless  => "alternatives --display java | grep '1.7.0'",
    }
  }

  class { 'jdk_oracle':
      version => $java_version,
  } ->
  set_up::value { 'set_java':
    value => 'java',
  } ->
  set_up::value { 'set_javac':
    value => 'javac',
  } ->
  set_up::value { 'set_jar':
    value => 'jar',
  }
}
