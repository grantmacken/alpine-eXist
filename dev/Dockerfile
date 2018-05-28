FROM openjdk:8-jre-alpine as packager
COPY --from=grantmacken/alpine-exist:base /usr/local/eXist /usr/local/eXist

RUN apk add --no-cache ttf-dejavu

ENV LANG C.UTF-8
EXPOSE 8080
ENV EXIST_HOME /usr/local/eXist
WORKDIR $EXIST_HOME
ENTRYPOINT ["java", "-Djava.awt.headless=true", "-jar", "start.jar", "jetty"]
