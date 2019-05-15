# [alpine-eXist](https://github.com/grantmacken/alpine-eXist)

minimal docker alpine image for exist-db

Available on [dockerhub](https://hub.docker.com/r/grantmacken/alpine-exist)

```
docker pull grantmacken/alpine-exist:v20190515
```

Images are built from the linux dist tarball.

Test build on [travis-ci](https://travis-ci.org/grantmacken/alpine-eXist)

[![Build Status](https://travis-ci.org/grantmacken/alpine-eXist.svg?branch=master)](https://travis-ci.org/grantmacken/alpine-eXist)
![GitHub last commit](https://img.shields.io/github/last-commit/grantmacken/alpine-eXist.svg)

## Why Alpine

 - [openjdk-roadmap-for-containers](https://blogs.oracle.com/developers/official-docker-image-for-oracle-java-and-the-openjdk-roadmap-for-containers)
 - You are most likely already have alpine layers in your container stack
 - You might want minimal size image but also be able use shell commands (ls rm etc)

If you don't want to use a shell commands, 
a minimal offical eXist [distroless version is available](from https://github.com/eXist-db/docker-existdb) 


## Requirements
*   [Docker](https://www.docker.com)

## Running the Container
Pre-build images are available on [dockerhub](https://hub.docker.com/r/grantmacken/alpine-exist/)

The latest build will always be the latest eXist release.

```
docker pull grantmacken/alpine-exist:latest
docker run -p 8080:8080 grantmacken/alpine-exist:latest -d
```

Earlier tagged 
[tagged images](https://hub.docker.com/r/grantmacken/alpine-exist/tags)
images based on earlier eXist versions may be available


### Local Development with docker-compose

This repo provides a docker-compose file: 'docker-compose.yml'

To bring the container up/down on port 8080 use

```
# power up
docker-compose up -d
# view eXist log
docker logs ex
# power down
docker-compose down
```

The  [eXist dashboard](http://localhost:8080/)
will now be available on localhost port 8080

#### Caveat

The eXist dba `user` is the default `admin`.
User password is also admin so change it ASAP

You may do this via the eXist
[usermanager](http://localhost:8080/exist/apps/usermanager/index.html)
 or see section 'Talking To eXist' below

### Starting Stopping eXist

Once eXist is up and running in a docker container,
you should now be able to stop and start eXist with the following commands

```
docker start ex
docker stop ex
```

### Docker run time environment

The docker-compose run time environment includes
1. A container name 'ex'.
2. A persistent docker volume named 'data' so the
important stuff in `${EXIST_HOME}/${EXIST_DATA_DIR}`
hangs around.
3. A docker volume named 'config' to allow you to make changes to eXist startup options
4. A network named 'www'.
5. A port published on 8080

#### If docker-compose is not available

On your remote host docker-compose might not be available.
The equivalent docker commands to issue are

```
docker network create --driver=bridge www
docker volume create --driver=local data
docker volume create --driver=local config
docker run \
  --name ex \
  --network www \
  --volume data:/usr/local/eXist/webapp/WEB-INF/data \
  --volume data:/usr/local/eXist/config \
  --publish 8080:8080 \
  -d \
  grantmacken/alpine-exist:latest'
```

### Using a Containerised Reverse Proxy

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

## Docker Image Environment

1. in $PATH the *java* exec is available
2. the following ENV vars
    * JAVA_HOME
    * EXIST_HOME
3.  the working directory is located in root directory of the eXist installation.

## Talking To eXist

When the docker image is up and running  `docker-compose up -d`  
you can issue execute commands on the running container.

## Building Image

```
git clone https://github.com/grantmacken/alpine-eXist.git
cd alpine-eXist
make
```



