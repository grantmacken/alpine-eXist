SHELL := /bin/bash
.ONESHELL:
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules
MAKEFLAGS += --silent
include .env 
EXIST_DIST := exist-distribution-$(EXIST_VER)
EXIST_HOME=/usr/local/exist
JAVA_HOME := /usr/lib/jvm/default-jvm/jre
LANG := C.UTF-8

JAVA_TOOL_OPTIONS := '-Dfile.encoding=UTF8 \
-Dsun.jnu.encoding=UTF-8 \
-Djava.awt.headless=true \
-Dorg.exist.db-connection.cacheSize=256M \
-Dorg.exist.db-connection.pool.max=20 \
-Dlog4j.configurationFile=$(EXIST_HOME)/etc/log4j2.xml \
-Dexist.home=$(EXIST_HOME) \
-Dexist.configurationFile=$(EXIST_HOME)/etc/conf.xml \
-Djetty.home=$(EXIST_HOME) \
-Dexist.jetty.config=$(EXIST_HOME)/etc/jetty/standard.enabled-jetty-configs \
 -XX:+UseG1GC \
 -XX:+UseStringDeduplication \
 -XX:+UseContainerSupport \
 -XX:MaxRAMPercentage=75.0 \
 -XX:+ExitOnOutOfMemoryError'

CLASSPATH :=  '$(EXIST_HOME)/lib/*'

LABELS :=

default: build

.PHONY: help
help: ## show this help	
	@cat $(MAKEFILE_LIST) | 
	grep -oP '^[a-zA-Z_-]+:.*?## .*$$' |
	sort |
	awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}-'

fetch: $(EXIST_DIST)/README.md
	echo "## $@ ##"

build: fetch
	echo "## $@ ##"
	mkdir -p exist/{lib,autodeploy,etc,logs}
	buildah from --name Alpine alpine:latest
	buildah run Alpine /bin/ash -c 'apk add openjdk8-jre-base'
	cd $(EXIST_DIST)
	for i in LICENSE README.md
	do cp $$i ../exist
	done
	for i in etc lib autodeploy
	do cp -r $$i ../exist
	done
	cd ../
	tar -c exist | buildah run Alpine /bin/ash -c 'tar -C /usr/local -xvf - '
	buildah config \
	  --env CLASSPATH=$(CLASSPATH) \
	  --env JAVA_TOOL_OPTIONS=$(JAVA_TOOL_OPTIONS) \
	  --env LANG=$(LANG) \
	  --env HOME=/home \
	  --env EXIST_HOME=$(EXIST_HOME) \
	  --env JAVA_HOME=$(JAVA_HOME) \
	  --env PATH="$(JAVA_HOME)/bin:$$PATH" \
	  --cmd  '' \
	  --entrypoint '[ "java","org.exist.start.Main", "jetty"] ' \
	  --workingdir $(EXIST_HOME) \
	  --stop-signal SIGTERM \
	  --label org.opencontainers.image.base.name=alpine \
	  --label org.opencontainers.image.title='xqerl' \
	  --label org.opencontainers.image.description='Erlang XQuery 3.1 Processor and XML Database' \
	  --label org.opencontainers.image.source=https://github.com/grantmacken/alpine-eXist \
	  --label org.opencontainers.image.documentation=https://github.com/grantmacken/alpine-eXist \
	  --label org.opencontainers.image.version=$(EXIST_VER)  Alpine
	buildah commit --squash Alpine localhost/existdb:v$(EXIST_VER)

$(EXIST_DIST)/README.md:
	echo "## $@ ##"
	wget -q -nc --show-progress https://github.com/eXist-db/exist/releases/download/eXist-$(EXIST_VER)/$(EXIST_DIST)-unix.tar.bz2 -O - | tar -xj

# && cd /usr/lib/jvm/java-1.8-openjdk/bin \
# && rm -rv orbd pack200 rmid rmiregistry servertool tnameserv unpack200 \
# && cd /usr/lib/jvm/java-1.8-openjdk/jre/lib/ext \
# && rm -v nashorn.jar

.PHONY: run
run:
	podman images
	podman run --name ex --publish 8080:8080  \
	  --detach localhost/existdb:v$(EXIST_VER)
	sleep 10
	echo ' - display container log '
	if podman logs ex | tail grep -q 'Error'
	then
	 podman logs ex | tail grep -oP 'Error.+$$'
	 false
	else
	podman logs ex 
	fi
	echo -n ' - check status and running size: '
	podman ps --size --format "{{.Names}} {{.Status}} {{.Size}}"
	echo ' - display the running processes of the container: '
	podman top ex user pid %C

.PHONY: clean
clean:
	rm -vR $(EXIST_DIST) || true
	rm -vR exist || true

