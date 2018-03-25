#DOCKER TARGETS

DOCKER_IMAGE ?= grantmacken/alpine-exist
GH_PRE := ^git@github\.com:
GH_SUB := https://github.com/
GH_SUF := \.git$


T := tmp
ifeq ($(wildcard $(T)),)
 $(shell  mkdir $(T))
endif

P := admin

.SECONDARY:

default: exInstall

build: VERSION
	@echo "## $@ ##"
	@echo 'TASK: build the docker image'
	@docker build \
 --tag="$(DOCKER_IMAGE)" \
 .

push:
	@docker push $(DOCKER_IMAGE):latest

exInstallDownload:
	@echo "## $@ ##"
	@$(MAKE) --silent $(T)/eXist-latest.version
	@cat $(T)/eXist-latest.version
	@echo '------------------------------------'

exInstall: exInstallDownload
exInstall:
	@echo "## $@ ##"
	@$(MAKE) --silent $(T)/wget-eXist.log
	@$(MAKE) --silent $(T)/eXist-expect.log
	@echo '======================================='

$(T)/eXist-latest.version:
	@echo "## $@ ##"
	@mkdir -p $(@D)
	@echo 'TASK: use curl to fetch the latest eXist version'
	@echo $(strip  \
 $(shell \
 curl -s -L https://bintray.com/existdb/releases/exist/_latestVersion  | \
 grep -oE 'eXist-db-setup-([0-9]+\.){2}([0-9]+)\.jar' | head -1) ) > $(@)
	@echo '------------------------------------'

$(T)/wget-eXist.log:  $(T)/eXist-latest.version
	@echo "## $(notdir $@) ##"
	@echo 'TASK: use wget to fetch $$(cat $<)'
	@wget -o $@ -O "$(T)/$$(cat $<)" \
 --trust-server-name --server-response --quiet --show-progress --no-clobber \
 "https://bintray.com/artifact/download/existdb/releases/$$(cat $<)"
	@echo '------------------------------------'

$(T)/eXist.expect: $(T)/wget-eXist.log
	@echo "## $(notdir $@) ##"
	@echo 'TASK: creating expect file'
	@echo '#!$(shell which expect) -f' > $(@)
	@echo exit
	echo 'spawn java -jar $(T)/$(shell cat tmp/eXist-latest.version) -console' >> $(@)
	@echo 'expect "Select target path" { send "$(EXIST_HOME)\n" }'  >> $(@)
	@echo 'expect "*ress 1" { send "1\n" }'  >> $(@)
	@echo 'expect "Set Data Directory" { send "$(EXIST_DATA_DIR)\n" }' >> $(@)
	@echo 'expect "*ress 1" { send "1\n" }' >> $(@)
	@echo 'expect "*ress 1" { send "1\n" }' >> $(@)
	@echo 'expect "Enter password" { send "$(P)\n" }' >> $(@)
	@echo 'expect "Enter password" { send "$(P)\n" }' >> $(@)
	@echo 'expect "Maximum memory" { send "\n" }'  >> $(@)
	@echo 'expect "Cache memory" { send "\n" }'  >> $(@)
	@echo 'expect "*ress 1" {send "1\n"}'  >> $(@)
	@echo 'expect -timeout -1 "Console installation done" {' >> $(@)
	@echo ' wait'  >> $(@)
	@echo ' exit'  >> $(@)
	@echo '}'  >> $(@)
	@chmod +x $(@)
	@echo '---------------------------------------'

$(T)/eXist-expect.log: $(T)/eXist.expect
	@echo "## $(notdir $@) ##"
	@echo "TASK: install eXist via expect script. Be Patient! this can take a few minutes"
	@$(<) | tee $(@)
	@echo '---------------------------------------'
