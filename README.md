# alpine-eXist
[WIP] minimal docker image for eXistdb

[![Build Status](https://travis-ci.org/grantmacken/alpine-eXist.svg?branch=master)](https://travis-ci.org/grantmacken/alpine-eXist)

![GitHub last commit](https://img.shields.io/github/last-commit/grantmacken/alpine-eXist.svg)
[![](https://images.microbadger.com/badges/image/grantmacken/alpine-exist.svg)](https://microbadger.com/images/grantmacken/alpine-exist "Get your own image badge on microbadger.com")
[![](https://images.microbadger.com/badges/version/grantmacken/alpine-exist.svg)](https://microbadger.com/images/grantmacken/alpine-exist "Get your own version badge on microbadger.com")

Built from openjdk:8-jre-alpine image [![](https://images.microbadger.com/badges/image/openjdk:8-jre-alpine.svg)](https://microbadger.com/images/openjdk:8-jre-alpine "Get your own image badge on microbadger.com")

## for local dev use docker-compose

```
docker-compose up
docker-compose down
```

The docker-compose file creates a
persistent docker volume 'data' so the
important stuff in `${EXIST_HOME}/${EXIST_DATA_DIR}`
hangs around.

## password

There is none, so change this ASAP
dba user is admin

## disable entrypoint to look into container

```
docker run --entrypoint "" grantmacken/alpine-exist:latest ls .
docker run --entrypoint "" grantmacken/alpine-exist:latest which java
docker run --entrypoint "" grantmacken/alpine-exist:latest ls /usr/lib/jvm
```
