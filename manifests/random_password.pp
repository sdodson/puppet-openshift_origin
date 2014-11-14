# Generates a random password file /etc/openshift/random_password to be used by multiple
# services that require a password but don't need to be shared with other roles
class openshift_origin::random_password {
  file  { '/etc/openshift/random_password':
    mode    => '0600',
    content => inline_template('<%= require "securerandom"; SecureRandom.base64 %>'),
    replace => false,
  }
}
