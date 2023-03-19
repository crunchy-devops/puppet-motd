node default {
  class { 'motd:motd':
    content => "Hello world\n",
  }
}