FROM openjdk:8-jre-alpine as packager
# exposes java in $PATH
# and following ENV
# JAVA_HOME
# PATH
# JAVA_ALPINE_VERSION

LABEL maintainer="Grant Mackenzie <grantmacken@gmail.com>" \
      org.label-schema.build-date="$(date --iso)" \
      org.label-schema.vcs-ref="$(git rev-parse --short HEAD)" \
      org.label-schema.vcs-url="https://github.com/grantmacken/alpine-eXist"
      org.label-schema.version="0.0.1" \
      org.label-schema.schema-version="1.0"

ENV EXIST_HOME /user/local/eXist
ENV EXIST_DATA_DIR webapp/WEB_INF/data
ENV MAX_MEMORY 512
ENV INSTALL_PATH /grantmacken
RUN mkdir -p $INSTALL_PATH
WORKDIR $INSTALL_PATH
COPY Makefile Makefile
RUN apk add --no-cache --virtual .build-deps \
        build-base \
        curl \
        wget \
        perl \
        expect \
        && make -j$(grep ^proces /proc/cpuinfo | wc -l) \
        && rm -rf tmp \
        && apk del .build-deps

FROM openjdk:8-jre-alpine
ENV EXIST_HOME /user/local/eXist
ENV EXIST_DATA_DIR webapp/WEB_INF/data
COPY --from=packager /user/local/eXist /user/local/eXist

ENV LANG C.UTF-8
EXPOSE 8080
# #  VOLUME $EXIST_DATA_DIR
WORKDIR $EXIST_HOME
ENTRYPOINT ["java", "-Djava.awt.headless=true", "-jar", "start.jar", "jetty"]
