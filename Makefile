include .env

colon := :
$(colon) := :

VERSION != curl -s "https://api.github.com/repos/eXist-db/exist/releases" | \
 grep -oP "tag_name(.+)eXist-\K([0-9]+\.){2}([0-9]+)(?=\")" | head -1

default: build

build:
	@echo "## $@ ##"
	@echo 'TASK: build the docker image '
	@echo "latest ver: $(DOCKER_IMAGE)$(colon)$(VERSION)"
	@docker build \
 --build-arg "VERSION=$(VERSION)" \
 --tag="$(DOCKER_IMAGE)$(colon)v$(VERSION)" \
 --tag="$(DOCKER_IMAGE)$(colon)$(DOCKER_TAG)" \
 .

build-base:
	@echo "## $@ ##"
	@echo 'TASK: build the docker image '
	@echo "latest ver: $(DOCKER_IMAGE)$(colon)base-v$(VERSION)"
	@docker build \
 --target base \
 --build-arg "VERSION=$(VERSION)" \
 --target base \
 --tag="$(DOCKER_IMAGE)$(colon)base-v$(VERSION)" \
 .

build-maker:
	@echo "## $@ ##"
	@echo 'TASK: build the docker image '
	@echo "latest ver: $(DOCKER_IMAGE)$(colon)maker-v$(VERSION)"
	@docker build \
 --build-arg "VERSION=$(VERSION)" \
 --target maker\
 --tag="$(DOCKER_IMAGE)$(colon)maker-v$(VERSION)" \
 .

push:
	@docker push $(DOCKER_IMAGE)$(colon)v$(VERSION)
	@docker push $(DOCKER_IMAGE)$(colon)$(DOCKER_TAG)


clean:
	@docker images -a | grep "grantmacken" | awk '{print $3}' | xargs docker rmi

up:
	@docker-compose up -d
	@#docker attach ex
	@#docker run -it --rm $(DOCKER_IMAGE):$(DOCKER_TAG) /bin/ash

down:
	@docker-compose down

log:
	@docker logs ex
