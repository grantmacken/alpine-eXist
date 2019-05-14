FROM  openjdk:8-jre-alpine3.9
# exposes java in $PATH
# and following ENV
# JAVA_HOME
LABEL maintainer="Grant Mackenzie <grantmacken@gmail.com>" \
      org.label-schema.build-date="$(date --iso)" \
      org.label-schema.vcs-ref="$(git rev-parse --short HEAD)" \
      org.label-schema.vcs-url="https://github.com/grantmacken/alpine-eXist" \
      org.label-schema.schema-version="1.0"

WORKDIR /home
ENV EXIST_HOME  "/usr/local/eXist"
ENV EXIST_DIST  "exist-distribution-5.0.0-RC8-SNAPSHOT"

RUN wget -q \
 http://static.adamretter.org.uk/${EXIST_DIST}-unix.tar.bz2  -O - |  tar -xj \
 && cd ${EXIST_DIST} \
 &&  mkdir -v -p $EXIST_HOME/logs \
 &&  mkdir -v -p $EXIST_HOME/autodeploy \
 && for i in \
  'LICENSE' \
  'README.md'; \
  do cp $i $EXIST_HOME; done \
 && for i in \
  'etc' \
  'lib'; \
  do cp -r $i $EXIST_HOME; done \
  && cd ../ && rm -r $EXIST_DIST \
  && cd /usr/lib/jvm/java-1.8-openjdk/bin \
  && rm -rv orbd pack200 rmid rmiregistry servertool tnameserv unpack200 \
  && cd /usr/lib/jvm/java-1.8-openjdk/jre/lib/ext \
  && rm -v nashorn.jar

ENV CLASSPATH \
"/usr/local/eXist/etc:\
/usr/local/eXist/lib/appassembler-booter-2.0.1-SNAPSHOT.jar:\
/usr/local/eXist/lib/appassembler-model-2.0.1-SNAPSHOT.jar:\
/usr/local/eXist/lib/plexus-utils-3.0.24.jar:\
/usr/local/eXist/lib/stax-api-1.0.1.jar:\
/usr/local/eXist/lib/stax-1.1.1-dev.jar"

WORKDIR $EXIST_HOME
ENV LANG C.UTF-8
EXPOSE 8080

ENTRYPOINT [\
"java",\
"-Djava.awt.headless=true",\ 
"-Dlog4j.configurationFile=/usr/local/eXist/etc/log4j2.xml",\ 
"-Dexist.home=/usr/local/eXist",\ 
"-Dexist.configurationFile=/usr/local/eXist/etc/conf.xml",\
"-Djetty.home=/usr/local/eXist",\ 
"-Dexist.jetty.config=/usr/local/eXist/etc/jetty/standard.enabled-jetty-configs",\ 
"-Dapp.name=startup",\ 
"-Dapp.pid=$$",\
"-Dapp.repo=/usr/local/eXist/lib",\
"-Dapp.home=/usr/local/eXist",\
"-Dbasedir=/usr/local/eXist",\
"-Dapp.pid=$$",\
"org.codehaus.mojo.appassembler.booter.AppassemblerBooter"\
]

