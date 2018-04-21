# alpine-eXist
[WIP] minimal docker image for exist-db

[![Build Status](https://travis-ci.org/grantmacken/alpine-eXist.svg?branch=master)](https://travis-ci.org/grantmacken/alpine-eXist)
![GitHub last commit](https://img.shields.io/github/last-commit/grantmacken/alpine-eXist.svg)
[![](https://images.microbadger.com/badges/image/grantmacken/alpine-exist.svg)](https://microbadger.com/images/grantmacken/alpine-exist "Get your own image badge on microbadger.com")
[![](https://images.microbadger.com/badges/version/grantmacken/alpine-exist.svg)](https://microbadger.com/images/grantmacken/alpine-exist "Get your own version badge on microbadger.com")

Built from openjdk:8-jre-alpine image [![](https://images.microbadger.com/badges/image/openjdk:8-jre-alpine.svg)](https://microbadger.com/images/openjdk:8-jre-alpine "Get your own image badge on microbadger.com")

## Requirements
*   [Docker](https://www.docker.com)

## Running the container
Pre-build images are available on [dockerhub](https://hub.docker.com/r/grantmacken/alpine-exist/)

You can simply download them and run the image as usual, e.g.:
`docker run -it -p 8080:8080 grantmacken/alpine-exist:latest`

dba user is the default `admin`.

## Caveat
There is no password so change it ASAP


## to look into the container...
you need to disable the entrypoint (using ""). You can now, e.g.:

```
docker run --entrypoint "" grantmacken/alpine-exist:latest ls .
docker run --entrypoint "" grantmacken/alpine-exist:latest which java
docker run --entrypoint "" grantmacken/alpine-exist:latest ls /usr/lib/jvm
```


## for local develpment use docker-compose
to start stop the container use:
```
docker-compose up -d
docker-compose down
```

The docker-compose file creates a
1. A container name 'ex'. 
2. A persistent docker volume named 'data' so the
important stuff in `${EXIST_HOME}/${EXIST_DATA_DIR}`
hangs around.
3. A network named 'www'. 

Be aware when using a reverse proxy in another container,
don't use 'localhost', use 'ex' ( our named container ) instead, 
and make sure it belongs to the same named docker 'www' network.

```
# nginx example
location @proxy {
  rewrite ^/?(.*)$ /exist/restxq/$domain/$1 break;
  proxy_pass http://ex:8080;
}
```

## Updating Image

To update the base image (of e.g. exist-db) use:
```
docker-compose pull
docker-compose up -d
```

you can inspect the container by running:
```
docker inspect ex
```
the name 'ex' is defined in `docker-compose.yml`



## Memory config
To modify -Xmx and CACHE_MEMORY configurations for your exist instance, change `MAX_MEM` and `CACHE_MEM` in `.env` and then build your image in the usual fashion:

```
cd alpine-eXist
docker build .
```

