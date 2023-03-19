node default {
  include motd::motd
  motd::motd { "test" :
    content => "Hello world\n",
  }
}