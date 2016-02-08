+++
date = "2016-02-08T05:51:13+01:00"
description = "Set up caddy on front of phabricator instance php-fpm"
title = "Caddy with phabricator"

+++

Needs caddy 0.8.1

```
https://domain {
  root /home/user/phabricator/webroot
    rewrite / /index.php?__path__=/
    rewrite  {
        to {path} {path}/ /index.php?__path__={path_escaped}&{query}
    }

  fastcgi / /var/run/php5-fpm.sock php
  errors /var/log/error.log
}

```

