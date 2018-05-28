
extractConfigs:
	@echo "## $@ ##"
	@docker ps -f name=ex | grep -oP 'exist' >/dev/null && echo 'OK!'
	@docker exec ex ls webapp/WEB-INF
	@docker cp ex:$(EXIST_HOME)/webapp/WEB-INF/controller-config.xml ./config/
	@docker exec ex ls .
	@docker cp ex:$(EXIST_HOME)/conf.xml ./config/
	@docker cp ex:$(EXIST_HOME)/log4j2.xml ./config/
	@docker cp ex:$(EXIST_HOME)/mime-types.xml ./config/
	@docker cp ex:$(EXIST_HOME)/descriptor.xml ./config/
	@docker cp ex:$(EXIST_HOME)/webapp/WEB-INF/controller-config.xml ./config/
	@docker cp ex:$(EXIST_HOME)/webapp/WEB-INF/web.xml ./config/
	@ls ./config/
