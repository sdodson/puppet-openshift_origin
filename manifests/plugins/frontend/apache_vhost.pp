# Copyright 2013 Mojo Lingo LLC.
# Modifications by Red Hat, Inc.
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.
#
class openshift_origin::plugins::frontend::apache_vhost {
  include openshift_origin::plugins::frontend::apache

  # apache-mod-rewrite and apache-vhost plugins are mutually exclusive
  # while we say that we're 'require'ing the package here, please note that
  # it's referencing the puppet resource that ensures the package is absent.
  package { 'rubygem-openshift-origin-frontend-apache-vhost':
    require =>  [ Class['openshift_origin::install_method'],
                  Package['rubygem-openshift-origin-frontend-apache-mod-rewrite'],
                ]
  }
  package { 'rubygem-openshift-origin-frontend-apache-mod-rewrite':
    ensure  => absent,
    require => Exec['prevent_node_frontend_changes'],
  }

  if member( $openshift_origin::roles, 'broker' ) {
    exec { 'Remove default 443 vhost when both broker and vhost plugin exist':
      command => '/bin/sed -i -e \'/<VirtualHost \*:443>/,/<\/VirtualHost/ s/^/#/\' /etc/httpd/conf.d/000001_openshift_origin_frontend_vhost.conf',
      onlyif  => '/bin/grep \'^<VirtualHost \*:443>\' /etc/httpd/conf.d/000001_openshift_origin_frontend_vhost.conf',
      require => Package['rubygem-openshift-origin-frontend-apache-vhost'],
    }
  }
}
