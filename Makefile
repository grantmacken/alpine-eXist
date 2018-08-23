include .env

T := tmp

default: $(T)/eXist-expect.log
	@echo ' remove install artifacts'
	rm -fr \
 $(EXIST_HOME)/bin \
 $(EXIST_HOME)/build \
 $(EXIST_HOME)/installer \
 $(EXIST_HOME)/samples \
 $(EXIST_HOME)/src \
 $(EXIST_HOME)/test \
 $(EXIST_HOME)/tools/Solaris \
 $(EXIST_HOME)/tools/appbundler \
 $(EXIST_HOME)/tools/rulesets \
 $(EXIST_HOME)/tools/yajsw \
 $(EXIST_HOME)/extensions/debuggee \
 $(EXIST_HOME)/extensions/exiftool \
 $(EXIST_HOME)/extensions/metadata \
 $(EXIST_HOME)/extensions/netedit \
 $(EXIST_HOME)/extensions/security \
 $(EXIST_HOME)/extensions/tomcat-realm \
 $(EXIST_HOME)/extensions/xprocxq \
 $(EXIST_HOME)/tools/jetty/webapps/portal \
 $(EXIST_HOME)/tools/jetty/standalone-webapps \
 $(EXIST_HOME)/tools/jetty/etc/standalone
	@rm -f \
 $(EXIST_HOME)/lib/extensions/xprocxq.jar \
 $(EXIST_HOME)/lib/extensions/exist-security-* \
 $(EXIST_HOME)/lib/extensions/exiftool.jar \
 $(EXIST_HOME)/uninstall.jar \
 $(EXIST_HOME)/.installationinformation \
 $(EXIST_HOME)/*.tmpl \
 $(EXIST_HOME)/*.log \
 $(EXIST_HOME)/*.xq \
 $(EXIST_HOME)/*.sh \
 $(EXIST_HOME)/icon.* \
 $(EXIST_HOME)/*.html \
 $(EXIST_HOME)/examples.jar \
 $(EXIST_HOME)/atom-services.xml \
 $(EXIST_HOME)/build.xml \
 $(EXIST_HOME)/build.properties \
 $(EXIST_HOME)/webapp/WEB-INF/*.tmpl \
 $(EXIST_HOME)/tools/jetty/etc/standalone* \
	@echo ' FIN '

ifeq ($(INC),inc)
include $(INC)/*.mk
endif

$(T)/eXist-latest.version:
	@echo "## $@ ##"
	@mkdir -p $(@D)
	@echo 'TASK: use curl to fetch the latest eXist version'
	@#TODO replace with after RC curl -s -L https://bintray.com/existdb/releases/exist/_latestVersion
	@echo $(strip  \
 $(shell \
 curl -s -L https://bintray.com/existdb/releases/exist/4.3.1  | \
 grep -oE 'eXist-db-setup-([0-9]+\.){2}([0-9]+)\.jar' | head -1) ) > $(@)
	@echo '------------------------------------'

$(T)/wget-eXist.log:  $(T)/eXist-latest.version
	@echo "## $(notdir $@) ##"
	@echo 'TASK: use wget to fetch $$(cat $<)'
	@wget -o $@ -O "$(T)/$$(cat $<)" \
 --trust-server-name --server-response --quiet  --show-progress  --progress=bar:force:noscroll --no-clobber \
 "https://bintray.com/artifact/download/existdb/releases/$$(cat $<)"
	@echo '------------------------------------'


$(T)/eXist.expect: $(T)/wget-eXist.log
	@echo "## $(notdir $@) ##"
	@echo 'TASK: creating expect file'
	@echo '#!$(shell which expect) -f' > $(@)
	@echo 'spawn java -jar $(T)/$(shell cat tmp/eXist-latest.version) -console' >> $(@)
	@echo 'expect "Select target path" { send "$(EXIST_HOME)\n" }'  >> $(@)
	@echo 'expect "*ress 1" { send "1\n" }'  >> $(@)
	@echo 'expect "Set Data Directory" { send "$(EXIST_DATA_DIR)\n" }' >> $(@)
	@echo 'expect "*ress 1" { send "1\n" }' >> $(@)
	@echo 'expect "*ress 1" { send "1\n" }' >> $(@)
	@echo 'expect "Enter password" { send "admin\n" }' >> $(@)
	@echo 'expect "Enter password" { send "admin\n" }' >> $(@)
	@echo 'expect "Maximum memory" { send "$(MAX_MEM)\n" }'  >> $(@)
	@echo 'expect "Cache memory" { send "$(CACHE_MEM)\n" }'  >> $(@)
	@echo 'expect "*ress 1" {send "1\n"}'  >> $(@)
	@echo 'expect -timeout -1 "Console installation done" {' >> $(@)
	@echo ' wait'  >> $(@)
	@echo ' exit'  >> $(@)
	@echo '}'  >> $(@)
	@echo '---------------------------------------'

$(T)/eXist-expect.log: $(T)/eXist.expect
	@echo "## $(notdir $@) ##"
	@echo "TASK: install eXist via expect script. Be Patient! this can take a few minutes"
	@chmod +x $(<)
	@$(<) | tee $(@)
	@echo '---------------------------------------'
