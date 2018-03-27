# alpine-eXist
[WIP] minimal docker image for eXistdb

[![Build Status](https://travis-ci.org/grantmacken/alpine-eXist.svg?branch=master)](https://travis-ci.org/grantmacken/alpine-eXist)

![GitHub last commit](https://img.shields.io/github/last-commit/grantmacken/alpine-eXist.svg)

[![](https://images.microbadger.com/badges/image/grantmacken/alpine-exist.svg)](https://microbadger.com/images/grantmacken/alpine-exist "Get your own image badge on microbadger.com")

[![](https://images.microbadger.com/badges/version/grantmacken/alpine-exist.svg)](https://microbadger.com/images/grantmacken/alpine-exist "Get your own version badge on microbadger.com")

FROM  openjdk:8-jre-alpine[![](https://images.microbadger.com/badges/image/openjdk:8-jre-alpine.svg)](https://microbadger.com/images/openjdk:8-jre-alpine "Get your own image badge on microbadger.com")


## specify port to run 
```
# run in detached mode
docker run -d -p 8181:8080 grantmacken/alpine-exist:latest
firefox http://localhost:8181
# if port 8080 is avaliable
docker run -d -p 8080:8080 grantmacken/alpine-exist:latest
firefox http://localhost:8080
```

## disable entrypoint to look into container

```
docker run --entrypoint "" grantmacken/alpine-exist:latest ls .
docker run --entrypoint "" grantmacken/alpine-exist:latest which java
docker run --entrypoint "" grantmacken/alpine-exist:latest ls /usr/lib/jvm
```
