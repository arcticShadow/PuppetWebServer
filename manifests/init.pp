$mynetworks = []
include postfix

node default {
    class { 'nginx': }
    nginx::resource::vhost { 'www.example.com':
        ensure   => present,
        www_root => '/var/www/www.example.com',
    }
    nginx::resource::vhost { 'www.isthistherealsiteoristhisjustfantasy.com':
        ensure   => present,
        www_root => '/var/www/www.isthistherealsiteoristhisjustfantasy.com',
    }
}
