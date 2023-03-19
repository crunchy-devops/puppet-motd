node default {
  notify { 'before': }
  class { 'motd':
    template => 'motd/motd.epp',
    content  => "Hello world\n",
  }
  notify { 'after': }
  include git-resource
  git { 'git_latest':
    path   => '/tmp/git_latest',
    ensure => present,
    origin => 'https://github.com/git/git.git',
  }
}