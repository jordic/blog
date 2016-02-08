+++
date = "2016-02-06T08:52:21+01:00"
description = ""
title = "Proting our nginx sites to Caddy"
category = ["devops"]
+++

## From nginx to caddy


[Caddy server](ttps://caddyserver.com) 

1. Caddy will serve automatic TLS from letsencrypt
2. Caddy will serve http/2
3. Caddy is developed in go: this means that is easy to understand it's codebase and also to contribute or add new features.
4. Caddy is as much performance as nginx.

These are some links and infos I'm collecting to start working with caddy in my infraestructure.

### Caddyfile
```
http://domain.com, https://domain.com {
    proxy / localhost:8000 {
        proxy_header Host {host}
        except /media /static
    }

   root /var/wwwr/xxx
}

```
### Upstart file for caddy.

```
description "Caddy Server startup script"
author "Mathias Beke"

start on runlevel [2345]
stop on runlevel [016]


setuid some-caddy-user
setgid some-caddy-group

respawn
respawn limit 10 5

limit nofile 4096 4096

script
    cd /home/mathias/
    exec ./caddy
end script
```

https://denbeke.be/blog/servers/running-caddy-server-as-a-service/



### Supervisor example, for gunicorn
```
[program:gunicorn]
command=/path/to/gunicorn main:application -c /path/to/gunicorn.conf.py
directory=/path/to/project
user=nobody
autostart=true
autorestart=true
redirect_stderr=true

```
