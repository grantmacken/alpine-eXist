
extractConfigs:
	docker cp ex:$(EXIST_HOME)/webapp/WEB-INF/controller-config.xml ./config

build: export EXIST_VERSION := $(shell \
 curl -s -L https://bintray.com/existdb/releases/exist/_latestVersion  | \
 grep -oE 'eXist-db-setup-([0-9]+\.){2}([0-9]+)\.jar' | head -1 | grep -oE '([0-9]+\.){2}([0-9]+)' )
build:
	@echo "## $@ ##"
	@echo 'TASK: build the docker image'
	@echo "latest eXist version $$EXIST_VERSION"
	@docker build \
 --tag="$(DOCKER_IMAGE):base" \
 --tag="$(DOCKER_IMAGE):base-$$EXIST_VERSION" \
 --tag="$(DOCKER_IMAGE):latest" .

push: export EXIST_VERSION := $(shell \
 curl -s -L https://bintray.com/existdb/releases/exist/_latestVersion  | \
 grep -oE 'eXist-db-setup-([0-9]+\.){2}([0-9]+)\.jar' | head -1 | grep -oE '([0-9]+\.){2}([0-9]+)' )
push:
	@docker push $(DOCKER_IMAGE):base
	@docker push $(DOCKER_IMAGE):base-$$EXIST_VERSION
	@docker push $(DOCKER_IMAGE):latest

pull: export EXIST_VERSION := $(shell \
 curl -s -L https://bintray.com/existdb/releases/exist/_latestVersion  | \
 grep -oE 'eXist-db-setup-([0-9]+\.){2}([0-9]+)\.jar' | head -1 | grep -oE '([0-9]+\.){2}([0-9]+)' )
pull:
	@docker push $(DOCKER_IMAGE):$$EXIST_VERSION

