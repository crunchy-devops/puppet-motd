node default {
  notify { 'before': }
  class { 'motd::motd':
    content => "Hello world\n",
  }
  notify { 'after': }
}