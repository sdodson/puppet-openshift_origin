class openshift_origin::role::load_balancer inherits openshift_origin::role {
  include openshift_origin::load_balancer

  openshift_origin::register_dns{ 'register virtual broker dns':
    fqdn    => $::openshift_origin::broker_virtual_hostname,
    role    => 'load_balancer',
    require => Class['openshift_origin::load_balancer'],
  }
}
