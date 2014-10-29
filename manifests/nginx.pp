class openshift_origin::nginx {
  if $::openshift_origin::manage_firewall {
    include openshift_origin::firewall::apache
  }

  package {
    [
      'nginx14-nginx',
      'rubygem-openshift-origin-routing-daemon',
    ]:
    ensure  => present,
  }
  ensure_resource( 'selboolean', 'httpd_can_network_connect', {
      value       => on,
      persistent  => true,
    }
  )

  service { 'nginx14-nginx':
    ensure     => true,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
    require    => Package['nginx14-nginx'],
  }
  
  service { 'openshift-routing-daemon':
    ensure     => true,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
    require    => Package['rubygem-openshift-origin-routing-daemon'],
  }
  
  file { 'routing-daemon':
    ensure  => present,
    path    => '/etc/openshift/routing-daemon.conf',
    content => template('openshift_origin/nginx/routing-daemon.conf.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => Package['rubygem-openshift-origin-routing-daemon'],
  }

}
