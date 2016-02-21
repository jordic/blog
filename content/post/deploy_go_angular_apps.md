+++
date = "2016-02-21T07:35:20+01:00"
description = "Different approaches to deploy Go backend apps with an Angular Frontend"
title = "Deploying Go + Angular Applications"

+++

## TL;DR

Distribute a go backend service with an angular frontend. Three ways of deploying a go application.

A Go application when it's compiled has no dependencies: just a single binary file 
that can be executed on every machine you want. Obviously you need to take care of the
architecture, and compile for the correct one.

Our first approach would be to deploy it as is.. without any external tooling. 

## No extra tooling

**You have**: a single binary file for the backend go application, and a folder, with some 
static files that will have to be served from your SPA.

```
/app/backend
/app/dist/index.html
/app/dist/scripts/app.js
/app/dist/css/app.css
```
Someone will told you that you need a webserver for serving the static files from the SPA. 
But there is no need. Go, has a good webserver integrated on the Standard Lib, that is 
capable of serving your static files on the same way that Nginx will do. You just need to 
declare a flag, or a env config on your backend, pointing to the app path files. And then
from the backend, serve the files, with something like:

```
http.Handle("/", http.FileServer(http.Dir(*staticDir)))

```

This approach is fine, when you deploy, you just need to copy the files to server, and launch
the binary. Sure, you can make a small bash script, that does it indirectly, first, creates 
a new folder with the release, and later, ln it  just before relaunch the 
service with the new configuration (to make it atomic)


## Append the static files to the go binary.

OK, past approach seems correct for a lot of use cases. But what happens if you want to offer
your application as a single binary. (For devops tooling for example). You will need that people
download a binary, copy it to some path on their systems, and later copy the static files, 
to some other path, and every time they launch the binary, they need to take care on where, 
the SAP client application is stored.

Go has super good solutions to solve this approach and distribute a single binary file, with the 
client files appended to it. There are other solutions, but I use this:

https://github.com/elazarl/go-bindata-assetfs

Every time you build a new release, you need to append static files to the binary, doing:

```
$ go-bin-data data/...
```

This command will generate a bindata.go file in your project dir, that will allow to serve the 
static files from the main binary, just doing this:

```
http.Handle("/", http.FileServer(assetsFs()))
```
On the options you can tune, there's a flag for when developing, that allow to serve directly files
from disk, using the same function call. This way, you just develop as usual, and on the end, 
when you want to release the application, you just need to "generate" the bin data file.

Usually I do this, putting it on a Makefile, and also, when possible compiling a static binary go, 
without cgo (no libc dependencies):

```
all: compile

compile: assets-production
	CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o main .

assets-production:
    go-bindata-assetsfs --prefix ../../ ../../dist/...

assets-dev:
    go-bindata-assetsfs --debug --prefix ../../ ../../dist/...

```

This approach is super clean, you end up with a single binary that has the
backend server and also the javascript frontend SAP client. A big win, just
launch it and you have a complete distributively and multiplataform application.

## Distribute with a docker

Our third approach involves using http://docker.com

This is also a easy way of distributing a go app, but this time, you don't need to 
append the static files to the binary, is better to copy the static folder to 
the docker image. Coming from the binary file compiled before, we can start with 
a Dockerfile like this:

```
FROM SCRATCH
COPY app/dist /dist
ADD  backend backend

CMD = ["/backend "-static", "dist/"]

```

If you can distribute your application with Docker, this is the more clean approach, you 
end app, with an image, that only contains your binary application, plus, your compiled, 
Angular SAP Client. On one layer for each one. 

If you change the backend, only the backend layer gets overwritten, also the same for 
the client.

For this we also use makefiles for building the application, something like this:

```
VERSION = r1
PREFIX = yourrepourl

docker_build:
	docker build -t $(PREFIX):$(VERSION) .
	docker tag  $(PREFIX):$(VERSION) $(PREFIX):$(VERSION)

push:
	docker push $(PREFIX):$(VERSION)
```
