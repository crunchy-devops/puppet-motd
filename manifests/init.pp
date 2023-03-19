node default {
  notify { 'before': }
  class { 'motd':
    content => "Hello world\n",
  }
  notify { 'after': }
}