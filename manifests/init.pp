node default {
  notify { 'before': }
  class { 'motd':
    template => 'motd/motd.epp',
    content => "Hello world\n",
  }
  notify { 'after': }
}