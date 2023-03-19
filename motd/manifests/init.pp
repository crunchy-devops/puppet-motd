# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include motd::exercice1
class motd (
  Boolean $dynamic_motd                    = true,
  Optional[String] $template               = undef,
  Optional[String] $content                = undef,
  Optional[String] $issue_template         = undef,
  Optional[String] $issue_content          = undef,
  Optional[String] $issue_net_template     = undef,
  Optional[String] $issue_net_content      = undef,
  String $windows_motd_title               = 'Message of the day',

){
  if $template {
    if $content {
      warning('Both $template and $content parameters passed to motd, ignoring content')
    }
    $motd_content = epp($template)
  } elsif $content {
    $motd_content = $content
  } else {
    $motd_content = epp('motd/motd.epp')
  }
  if $issue_template {
    if $issue_content {
      warning('Both $issue_template and $issue_content parameters passed to motd, ignoring content')
    }
    $_issue_content = epp($issue_template)
  } elsif $issue_content {
    $_issue_content = $issue_conten
  } else {
    $_issue_content = false
  }
  if $issue_net_template{
    if $issue_net_content{
      warning('Both $issue_net_template and $issue_net_content parameters passed to motd, ignoring content')
    }
    $_issue_net_content = epp($issue_net_template)
  } elsif $issue_net_content {
    $_issue_net_content = $issue_net_content
  } else {
    $_issue_net_content = false
  }
  $owner = $facts['kernel'] ? {
    'AIX' => 'bin',
    default => 'root',
  }
  $group = $facts['kernel'] ? {
    'AIX' => 'bin',
    'FreeBSD' => 'wheel',
    default => 'root',
  }
  $mode = $facts['kernel'] ? {
    default =>'0644',
  }

  File {
    owner => $owner,
    group => $group,
    mode => $mode,
  }
  if $facts['kernel'] in ['Linux','SunOS','FreeBSD','AIX']{
    if $facts['kernel']  == 'FresBSD' {
      if versioncmp ($facts['os']['release']['major'],'13') >= 0 {
        $_motd_location ='/etc/motd.template'
      } else {
        $_motd_location = '/etc/motd'
      }
    } else {
      $_motd_location = '/etc/motd'
      if $_issue_content {
        file { '/etc/issue':
          ensure  => file,
          backup  => false,
          content => $_issue_content,
        }
      }
      if $_issue_net_content {
        file { '/etc/issue.net':
          ensure  => file,
          backup  => false,
          content => $_issue_net_content,
        }
      }
    }
    file { $_motd_location:
      ensure  => file,
      backup  => false,
      content => $motd_content,
    }
    if ($facts['osfamily'] == 'Debian') and ($dynamic_motd == false) {
      if $facts['operatingsystem'] == 'Debian' and versioncmp($facts['operatingsystemmajrelease'], '7') > 0 {
        $_line_to_remove = 'session    optional     pam_motd.so  motd=/run/motd.dynamic'
      } elsif $facts['operatingsystem'] == 'Ubuntu' and versioncmp($facts['operatingsystemmajrelease'], '16.00') > 0 {
        $_line_to_remove = 'session    optional     pam_motd.so  motd=/run/motd.dynamic'
      } else {
        $_line_to_remove = 'session    optional     pam_motd.so  motd=/run/motd.dynamic noupdate'
      }

      file_line { 'dynamic_motd':
        ensure => absent,
        path   => '/etc/pam.d/sshd',
        line   => $_line_to_remove,
      }
    }
  } elsif $facts['kernel'] == 'windows' {
    registry_value { 'HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\policies\system\legalnoticecaption':
      ensure => present,
      type   => string,
      data   => $windows_motd_title,
    }
    registry_value { 'HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\policies\system\legalnoticetext':
      ensure => present,
      type   => string,
      data   => $motd_content,
    }
  }
}

