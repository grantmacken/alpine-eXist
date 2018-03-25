FROM openjdk:8-jre-alpine
# exposes $JAVA_HOME

LABEL maintainer="Grant Mackenzie <grantmacken@gmail.com>"

ENV EXIST_HOME /user/local/eXist
ENV EXIST_DATA_DIR webapp/WEB_INF/data
ENV MAX_MEMORY 512
ENV INSTALL_PATH /grantmacken
RUN mkdir -p $INSTALL_PATH
WORKDIR $INSTALL_PATH
RUN apk add --no-cache --virtual .build-deps \
        bash \
        build-base \
        perl \
        curl \
        wget \
        expect


COPY Makefile Makefile
RUN make && \
 rm -rf tmp && \
 apk del .build-deps

ENV LANG C.UTF-8
EXPOSE 8080
# #  VOLUME $EXIST_DATA_DIR
WORKDIR $EXIST_HOME
ENTRYPOINT ["java", "-Djava.awt.headless=true", "-jar", "start.jar", "jetty"]
