# == Class: puppet::config
# DO NO CALL DIRECTLY
class puppet::config {

  # [main]
  ini_setting { 'logdir':
    section => 'main',
    setting => 'logdir',
    value   => '/var/log/puppet',
  }

  ini_setting { 'rundir':
    section => 'main',
    setting => 'rundir',
    value   => '/var/run/puppet',
  }

  ini_setting { 'vardir':
    section => 'main',
    setting => 'vardir',
    value   => '/var/lib/puppet',
  }

  ini_setting { 'ssldir':
    section => 'main',
    setting => 'ssldir',
    value   => '/var/lib/puppet/ssl',
  }

  ini_setting { 'basemodulepath':
    section => 'main',
    setting => 'basemodulepath',
    value   => '/etc/puppet/modules:/etc/puppet/sites',
  }

  ini_setting { 'pluginsync':
    section => 'main',
    setting => 'pluginsync',
    value   => true,
  }

  ini_setting { 'hiera_config':
    section => 'main',
    setting => 'hiera_config',
    value   => '/etc/puppet/hiera.yaml',
  }

  # [master]
  ini_setting { 'ssl_client_header':
    section => 'master',
    setting => 'ssl_client_header',
    value   => SSL_CLIENT_S_DN,
  }

  ini_setting { 'ssl_client_verify_header':
    section => 'master',
    setting => 'ssl_client_verify_header',
    value   => SSL_CLIENT_VERIFY,
  }

  ini_setting { 'autosign':
    section => 'master',
    setting => 'autosign',
    value   => '/etc/puppet/autosign.conf',
  }

  # [agent]
  ini_setting { 'server':
    section => 'agent',
    setting => 'server',
    value   => $puppet::server,
  }

  ini_setting { 'classfile':
    section => 'agent',
    setting => 'classfile',
    value   => '/var/lib/puppet/classes.txt',
  }

  ini_setting { 'runinterval':
    section => 'agent',
    setting => 'runinterval',
    value   => 3600,
  }

  ini_setting { 'splay':
    section => 'agent',
    setting => 'splay',
    value   => true,
  }

  # defaults for all settings
  Ini_setting {
    ensure  => present,
    path    => '/etc/puppet/puppet.conf',
    require => Package['puppet'],
    notify    => Service['puppet'],
  }
}
