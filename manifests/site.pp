node default {
  notify { 'before': }
  class { "puppet-motd::motd":
    content => "Hello world\n",
  }
  notify { 'after': }
}