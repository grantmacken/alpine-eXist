FROM grantmacken/alpine-base:maker as packager
# exposes java in $PATH
# and following ENV
# JAVA_HOME

ARG VERSION=4.3.1
LABEL maintainer="Grant Mackenzie <grantmacken@gmail.com>" \
      org.label-schema.build-date="$(date --iso)" \
      org.label-schema.vcs-ref="$(git rev-parse --short HEAD)" \
      org.label-schema.vcs-url="https://github.com/grantmacken/alpine-eXist" \
      org.label-schema.schema-version="1.0"

WORKDIR /home
COPY .env .env
COPY eXist.expect eXist.expect

RUN wget -O eXist-db-setup.jar \
 --trust-server-name --quiet  --show-progress  --progress=bar:force:noscroll --no-clobber \
 "https://bintray.com/artifact/download/existdb/releases/eXist-db-setup-${VERSION}.jar" \
 && export $(xargs <.env) \
 && chmod +x eXist.expect \
 && ./eXist.expect \
 && rm -fr \
 /usr/local/eXist/bin \
 /usr/local/eXist/build \
 /usr/local/eXist/extensions/debuggee \
 /usr/local/eXist/extensions/exiftool \
 /usr/local/eXist/extensions/metadata \
 /usr/local/eXist/extensions/netedit \
 /usr/local/eXist/extensions/security \
 /usr/local/eXist/extensions/tomcat-realm \
 /usr/local/eXist/extensions/xprocxq \
 /usr/local/eXist/installer \
 /usr/local/eXist/samples \
 /usr/local/eXist/src \
 /usr/local/eXist/test \
 /usr/local/eXist/tools/Solaris \
 /usr/local/eXist/tools/appbundler \
 /usr/local/eXist/tools/jetty/etc/standalone \ 
 /usr/local/eXist/tools/jetty/standalone-webapps \
 /usr/local/eXist/tools/jetty/webapps/portal \
 /usr/local/eXist/tools/rulesets \
 /usr/local/eXist/tools/yajsw \
 && rm -f \
 /usr/local/eXist/*.html \
 /usr/local/eXist/*.log \
 /usr/local/eXist/*.sh \
 /usr/local/eXist/*.tmpl \
 /usr/local/eXist/*.xq \
 /usr/local/eXist/.installationinformation \
 /usr/local/eXist/atom-services.xml \
 /usr/local/eXist/build.properties \
 /usr/local/eXist/build.xml \
 /usr/local/eXist/examples.jar \
 /usr/local/eXist/icon.* \
 /usr/local/eXist/lib/extensions/exiftool.jar \
 /usr/local/eXist/lib/extensions/exist-security-* \
 /usr/local/eXist/lib/extensions/xprocxq.jar \
 /usr/local/eXist/tools/jetty/etc/standalone* \
 /usr/local/eXist/uninstall.jar \
 /usr/local/eXist/webapp/WEB-INF/*.tmpl \
 & echo 'FIN'

FROM alpine:3.8 as base
COPY --from=packager /usr/local/eXist /usr/local/eXist
RUN apk add --no-cache openjdk8-jre-base

ENV LANG C.UTF-8
EXPOSE 8080
ENV EXIST_HOME /usr/local/eXist
ENV JAVA_HOME /usr/lib/jvm/default-jvm

WORKDIR $EXIST_HOME
ENTRYPOINT ["java", "-Djava.awt.headless=true", "-jar", "start.jar", "jetty"]
