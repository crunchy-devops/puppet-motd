# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include motd::exercice1
class motd::exercice1 {
  file { '/tmp/hello':
    ensure => file,
    content => 'Hello World',
    path => '/tmp/hello',
  }
}
