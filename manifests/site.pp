node default {
  include motd::motd
  class { 'motd::motd':
    content => "Hello world\n",
  }
}