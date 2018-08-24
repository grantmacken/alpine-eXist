include .env

colon := :
$(colon) := :

VERSION != curl -s "https://api.github.com/repos/eXist-db/exist/releases" | \
 grep -oP "tag_name(.+)eXist-\K([0-9]+\.){2}([0-9]+)(?=\")" | head -1

build:
	@echo "## $@ ##"
	@echo 'TASK: build the docker image '
	@echo "latest ver: $(DOCKER_IMAGE)$(colon)$(VERSION)"
	@docker build \
 --tag="$(DOCKER_IMAGE)$(colon)v$(VERSION)" \
 --tag="$(DOCKER_IMAGE)$(colon)$(DOCKER_TAG)" \
 .

push:
	@docker push $(DOCKER_IMAGE)$(colon)v$(VERSION)
	@docker push $(DOCKER_IMAGE)$(colon)$(DOCKER_TAG)
