# Class: javaimpl
#
# This class implements jdk_oracle module
#
class javaimpl(
  $java_version = hiera('java_version')
  ) {

  class { 'jdk_oracle':
      version => $java_version,
  } ->

  exec { 'set_up_java':
        command => 'sudo alternatives --install /usr/bin/java java /opt/jdk1.7.0_67/bin/java 1',
  } ->
  exec { 'set_up_javac':
        command => 'sudo alternatives --install /usr/bin/javac javac /opt/jdk1.7.0_67/bin/javac 1',
  } ->
  exec { 'set_up_jar':
        command => 'sudo alternatives --install /usr/bin/jar jar /opt/jdk1.7.0_67/bin/jar 1',
  }
}
