node default {
  class { "puppet-motd::motd":
    content => "Hello world\n",
  }
}