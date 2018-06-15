# alpine-eXist
[WIP] minimal docker image for exist-db

[![Build Status](https://travis-ci.org/grantmacken/alpine-eXist.svg?branch=master)](https://travis-ci.org/grantmacken/alpine-eXist)
![GitHub last commit](https://img.shields.io/github/last-commit/grantmacken/alpine-eXist.svg)
[![](https://images.microbadger.com/badges/image/grantmacken/alpine-exist.svg)](https://microbadger.com/images/grantmacken/alpine-exist "Get your own image badge on microbadger.com")
[![](https://images.microbadger.com/badges/version/grantmacken/alpine-exist.svg)](https://microbadger.com/images/grantmacken/alpine-exist "Get your own version badge on microbadger.com")

Built from openjdk:8-jre-alpine image [![](https://images.microbadger.com/badges/image/openjdk:8-jre-alpine.svg)](https://microbadger.com/images/openjdk:8-jre-alpine "Get your own image badge on microbadger.com")

## Why Alpine

 - [openjdk-roadmap-for-containers](https://blogs.oracle.com/developers/official-docker-image-for-oracle-java-and-the-openjdk-roadmap-for-containers)
 - You are most likely already have alpine layers in your container stack

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

The eXist dba user is the default `admin`.

There is no password so change it ASAP

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
3. A network named 'www'.
4. A port published on 8080

#### If docker-compose is not available

On your remote host docker-compose might not be available.
The equivalent docker commands to issue are

```
docker network create --driver=bridge www
docker volume create --driver=local data
docker run \
  --name ex \
  --network www \
  --volume data:/usr/local/eXist/webapp/WEB-INF/data \
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
    * JAVA_ALPINE_VERSION
3.  the working directory is located in root directory of the eXist installation.

## Talking To eXist

When the docker image is up and running  `docker-compose up -d`  
you can issue execute commands on the running container.

Examples:

```
# list EXIST_HOME dir contents
docker exec ex ls -al .
# get eXist version
docker exec ex java -jar start.jar client -q -u admin -P admin -x \
 'system:get-version()' | tail -1 ; echo
# list installed repos
docker exec ex java -jar start.jar client -q -u admin -P admin -x \
 'string-join(repo:list(), "&#10;")' ;  echo
# change the admin pass to 'nimda'
docker exec ex java -jar start.jar client -q -u admin -P admin -x \
 'sm:passwd("admin", "nimda")'
# change the admin pass back to admin
docker exec ex java -jar start.jar client -q -u admin -P nimda -x \
 'sm:passwd("admin", "admin")'
```

[![asciicast](https://asciinema.org/a/TdZmETn9AXLd72jaNQVPnPoeC.png)](https://asciinema.org/a/TdZmETn9AXLd72jaNQVPnPoeC)


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


## Building Image

Clone or Fork this repo.

### Memory config
To modify -Xmx and CACHE_MEMORY configurations for your exist instance, change `MAX_MEM` and `CACHE_MEM` in `.env` and then build your image in the usual fashion:

```
cd alpine-eXist
docker build .
```

### Build Preamble

1. beginning layers: alpine + openjdk:8-jre 
2. intermediate layer tagged as base.  This is the base eXist install
3. layers used-for: 
 - for desktop: tagged dev  
 - for cloud:   tagged prod  
4. image as packaged application layer. e.g.
 - for fop apps 

```
make build INC=inc
```
We start from the openjdk:8-jre-alpine image. On top of this layer, 
we install eXist from the latest install binary provided by the eXist developers.

Our first tagged *base* image is the openjdk jre + eXist with a  few things stripped out of the eXist install.
It should provide a similar experience as if the user installed eXist from the install binary.

From this base, the next stage is to get the image smaller to suit specific requirements.

# WIP below

## generic desktop development images 
 - keep tests env
 - keep logging env
 - remove any network services not required
 - remove unused modules ( check conf.xml , extensions/build.properties )

```
make build-dev INC=inc
```
 - alpine-eXist:dev  # the latest version
 - alpine-eXist:dev-v4.1.1  

# TODO below

## generic cloud production images
 - remove test env
 - remove any network services not required
 - remove unused modules
 - remove autodeploy folder
 - remove any expath packages not required
   - eXide
   - dashboard
   - shared

```
make build-prod INC=inc
```
 - alpine-eXist:prod  # the latest version
 - alpine-eXist:prod-v4.1.1  

## specfic development and production images

These to have their own Dockerfile
The images will be layered on top of the 
generic development and production images

example: image with FO support

 ```
make build-dev-fop
make build-prod-fop
```

 - alpine-eXist:prod-fop  # the latest version
 - alpine-eXist:prod-fop-v4.1.1  



