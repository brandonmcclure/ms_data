ifeq ($(OS),Windows_NT)
	SHELL := pwsh.exe
else
	SHELL := pwsh
endif

.SHELLFLAGS := -NoProfile -Command
STRUCTURIZR_CLI_CMD := structurizr
STRUCTURIZR_LITE_CMD := docker run -it --rm -p 8080:8080 -v $${PWD}:/usr/local/structurizr structurizr/lite
REGISTRY_NAME := 
REPOSITORY_NAME := bmcclure89/
CS_SA_PASSWORD := We@kP@ssword
TAG := :latest


.PHONY: all clean test lint act
all: build
# Act/github workflows
ACT_ARTIFACT_PATH := /workspace/.act 
act: 
lint: lint_makefile
lint_makefile:
	docker run -v $${PWD}:/tmp/lint -e ENABLE_LINTERS=MAKEFILE_CHECKMAKE oxsecurity/megalinter-ci_light:v6.10.0
precommit_install:
	pre-commit install
precommit_checkall: precommit_install
	pre-commit run --all-files
getcommitid: 
	$(eval COMMITID = $(shell git log -1 --pretty=format:"%H"))
getbranchname:
	$(eval BRANCH_NAME = $(shell (git branch --show-current ) -replace '/','.'))

build: getcommitid getbranchname build_prometheus build_nodeexporter build_grafana build_etl build_etl_persistblitz build_sql build_sql_test diagram_build_plantuml
build_prometheus:
	$(eval IMAGE_NAME = ms_prometheus)
	docker build -t $(REGISTRY_NAME)$(REPOSITORY_NAME)$(IMAGE_NAME)$(TAG) -t $(REGISTRY_NAME)$(REPOSITORY_NAME)$(IMAGE_NAME):$(BRANCH_NAME) -t $(REGISTRY_NAME)$(REPOSITORY_NAME)$(IMAGE_NAME):$(BRANCH_NAME)_$(COMMITID) ./src/prometheus
build_nodeexporter:
	$(eval IMAGE_NAME = ms_node_exporter)
	docker build -t $(REGISTRY_NAME)$(REPOSITORY_NAME)$(IMAGE_NAME)$(TAG) -t $(REGISTRY_NAME)$(REPOSITORY_NAME)$(IMAGE_NAME):$(BRANCH_NAME) -t $(REGISTRY_NAME)$(REPOSITORY_NAME)$(IMAGE_NAME):$(BRANCH_NAME)_$(COMMITID) ./src/node_exporter
build_grafana:
	$(eval IMAGE_NAME = ms_grafana)
	docker build -t $(REGISTRY_NAME)$(REPOSITORY_NAME)$(IMAGE_NAME)$(TAG) -t $(REGISTRY_NAME)$(REPOSITORY_NAME)$(IMAGE_NAME):$(BRANCH_NAME) -t $(REGISTRY_NAME)$(REPOSITORY_NAME)$(IMAGE_NAME):$(BRANCH_NAME)_$(COMMITID) ./src/grafana
build_etl:
	$(eval IMAGE_NAME = ms_etl)
	docker build -t $(REGISTRY_NAME)$(REPOSITORY_NAME)$(IMAGE_NAME)$(TAG) -t $(REGISTRY_NAME)$(REPOSITORY_NAME)$(IMAGE_NAME):$(BRANCH_NAME) -t $(REGISTRY_NAME)$(REPOSITORY_NAME)$(IMAGE_NAME):$(BRANCH_NAME)_$(COMMITID) ./src/ETL
build_etl_persistblitz:
	$(eval IMAGE_NAME = ms_etl_persistblitz)
	docker build --build-arg CD_SA_PASSWORD=$(CS_SA_PASSWORD) -t $(REGISTRY_NAME)$(REPOSITORY_NAME)$(IMAGE_NAME)$(TAG) -t $(REGISTRY_NAME)$(REPOSITORY_NAME)$(IMAGE_NAME):$(BRANCH_NAME) -t $(REGISTRY_NAME)$(REPOSITORY_NAME)$(IMAGE_NAME):$(BRANCH_NAME)_$(COMMITID) ./src/PersistSQLBlitz
build_sql:
	$(eval IMAGE_NAME = ms_sql)
	docker build --build-arg CD_SA_PASSWORD=$(CS_SA_PASSWORD) -t $(REGISTRY_NAME)$(REPOSITORY_NAME)$(IMAGE_NAME)$(TAG) -t $(REGISTRY_NAME)$(REPOSITORY_NAME)$(IMAGE_NAME):$(BRANCH_NAME) -t $(REGISTRY_NAME)$(REPOSITORY_NAME)$(IMAGE_NAME):$(BRANCH_NAME)_$(COMMITID) ./src/sql
build_sql_test:
	$(eval IMAGE_NAME = ms_sql_test)
	docker build --build-arg CD_SA_PASSWORD=$(CS_SA_PASSWORD) -t $(REGISTRY_NAME)$(REPOSITORY_NAME)$(IMAGE_NAME)$(TAG) -t $(REGISTRY_NAME)$(REPOSITORY_NAME)$(IMAGE_NAME):$(BRANCH_NAME) -t $(REGISTRY_NAME)$(REPOSITORY_NAME)$(IMAGE_NAME):$(BRANCH_NAME)_$(COMMITID) ./src/sql_test
	
diagram: diagram_build_plantuml

diagram_build_dsl:
	$(STRUCTURIZR_CLI_CMD) export -format plantuml/c4plantuml -workspace $${PWD}/workspace.dsl -output $${PWD}/bin/plantuml

diagram_build_plantuml: diagram_build_dsl
	./BuildTools/invoke-plantumlbuild.sh
diagram_run_server: diagram_build_plantuml
	$(STRUCTURIZR_LITE_CMD)

configure_env:
	If (-not (Test-Path .sql.env)){"MSSQL_SA_PASSWORD=$(CS_SA_PASSWORD)" | Set-Content .sql.env}
compose_up: configure_env
	@docker-compose -f docker-compose.yml up -d

compose_down:
	@docker compose -f docker-compose.yml down

clean:
	@docker-compose -f docker-compose.yml down -v --remove-orphans