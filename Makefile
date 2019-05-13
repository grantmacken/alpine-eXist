include .env

colon := :
$(colon) := :

#VERSION != curl -s "https://api.github.com/repos/eXist-db/exist/releases" | \
 grep -oP "tag_name(.+)eXist-\K([0-9]+\.){2}([0-9]+)(?=\")" | head -1

# VERSION := 4.5.0

default: build

.PHONY: build
build:
	@echo "## $@ ##"
	@echo 'TASK: build $(DOCKER_IMAGE)$(colon)$(DOCKER_TAG)'
	@docker build --tag="$(DOCKER_IMAGE)$(colon)$(DOCKER_TAG)" .

.PHONY: tag
tag:
	@echo 'v$(VERSION)'


.PHONY: push
push:
	@echo '## $@ ##'
	@echo '$(DOCKER_IMAGE)$(colon)$(DOCKER_TAG)'
	@docker images -a | grep -oP '$(DOCKER_IMAGE)(.+)$$'
	@#docker push $(DOCKER_IMAGE)$(colon)latest
	@docker push $(DOCKER_IMAGE)$(colon)$(DOCKER_TAG)

.PHONY: clean
clean:
	@docker images -a | grep "grantmacken" | awk '{print $3}' | xargs docker rmi

up:
	@docker-compose up
	@#docker attach ex
	@#docker run -it --rm $(DOCKER_IMAGE):$(DOCKER_TAG) /bin/ash

down:
	@docker-compose down

log:
	@docker logs exMaven

run:
	@docker run -it --rm $(DOCKER_IMAGE):$(DOCKER_TAG)
