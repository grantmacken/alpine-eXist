include .env
colon := :
$(colon) := :
default: build

.PHONY: build
build:
	@echo "## $@ ##"
	@echo 'TASK: build $(DOCKER_IMAGE)$(colon)$(DOCKER_TAG)'
	@docker build --tag="$(DOCKER_IMAGE)$(colon)$(DOCKER_TAG)" .
	@#docker build --no-cache --tag="$(DOCKER_IMAGE)$(colon)$(DOCKER_TAG)" .

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

.PHONY: up
up:
	@./bin/exStartUp

.PHONY: info
info:
	@./bin/xQinfo

.PHONY: down
down:
	@docker-compose down

.PHONY: log
log:
	@docker logs $(CONTAINER_NAME)

.PHONY: run
run:
	@docker run -it --rm $(DOCKER_IMAGE):$(DOCKER_TAG) /bin/ash

.PHONY: rec
rec:
	@mkdir -p ../tmp
	@clear
	@asciinema rec ../tmp/my.cast \
 --overwrite \
 --title="new maven dist tarball build" \
 --command="\
sleep 1 && printf %60s | tr ' ' '='  && echo && \
echo ' - pushing commits to github ... ' && \
git push && \
sleep 3 && printf %60s | tr ' ' '-'  && echo && \
echo ' - watching travis logs... ' && \
travis logs && \
sleep 1 && printf %60s | tr ' ' '='  && echo\
"

