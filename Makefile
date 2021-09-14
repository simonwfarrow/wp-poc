SHELL := /bin/bash

build: ## Builds this project [Default]
	mvn compile && mvn package

check-deps: ## Checks the required dependecies
	@printf "checking for java ... ";
	@if [ "`which java`" != "" ]; then echo "found"; else echo "missing"; fi

	@printf "checking for maven ... ";
	@if [ "`which mvn`" != "" ]; then echo "found"; else echo "missing"; fi

	@printf "checking for docker ... ";
	@if [ "`which docker`" != "" ]; then echo "found"; else echo "missing"; fi

	@printf "checking for docker-compose ... ";
	@if [ "`which docker-compose`" != "" ]; then echo "found"; else echo "missing"; fi

	@printf "checking for docker permissions ... ";
	@if [ "`docker ps | grep 'CONTAINER'`" != "" ]; then echo "pass"; else echo "fail"; fi

	@printf "checking for jq ... ";
	@if [ "`which jq`" != "" ]; then echo "found"; else echo "missing"; fi

init: docker-init ## Initializes the project

docker-init: ## Initializes the docker network adapter and creates required directories
	@if [ "`docker network ls | grep poc-wp`" == "" ]; then docker network create poc-wp; else echo "Docker network already exists"; fi
	mkdir -p `grep 'KAFKA_HOME' docker/kafka/.env | cut -d "=" -f 2`;
	mkdir -p `grep 'ELK_HOME' docker/elk/.env | cut -d "=" -f 2`/elasticsearch-data;

kafka-setup: ## Initializes the kafka topics
	docker exec -it kafka /bin/bash /opt/kafka/bin/kafka-topics.sh --create --if-not-exists --topic clearing-payment --bootstrap-server localhost:9092
	docker exec -it kafka /bin/bash /opt/kafka/bin/kafka-topics.sh --create --if-not-exists --topic clearing-internal --bootstrap-server localhost:9092
	docker exec -it kafka /bin/bash /opt/kafka/bin/kafka-topics.sh --create --if-not-exists --topic pricing-payment --bootstrap-server localhost:9092
	docker exec -it kafka /bin/bash /opt/kafka/bin/kafka-topics.sh --create --if-not-exists --topic pricing-internal --bootstrap-server localhost:9092

kafka-start: ## Starts the kafka docker service
	@export PWD=`pwd`
	@cd ${PWD}/docker/kafka; docker-compose up -d
	@cd ${PWD}

kafka-stop: ## Stops the kafka docker stack
	@export PWD=`pwd`;
	@cd ${PWD}/docker/kafka; docker-compose down;
	@cd ${PWD}

elk-start: ## Starts the ELK stack docker service
	@export PWD=`pwd`;
	@cd ${PWD}/docker/elk; docker-compose up -d;
	@cd ${PWD}

elk-stop: ## Stops the ELK stack docker service
	@export PWD=`pwd`;
	@cd ${PWD}/docker/elk; docker-compose down;
	@cd ${PWD}

postgres-start: #starts postgres instances
	@export PWD=`pwd`;
	@cd ${PWD}/docker/postgres-clearing; docker-compose up -d;
	@cd ${PWD}/docker/postgres-pricing; docker-compose up -d;
	@cd ${PWD}

postgres-stop: #stops postgres instances
	@export PWD=`pwd`;
	@cd ${PWD}/docker/postgres-clearing; docker-compose down;
	@cd ${PWD}/docker/postgres-pricing; docker-compose down;
	@cd ${PWD}

grafana-start: ## Starts the grafana instance
	@export PWD=`pwd`;
	@cd ${PWD}/docker/grafana; docker-compose up -d;
	@cd ${PWD}

grafana-stop: ## Stops the grafana instance
	@export PWD=`pwd`;
	@cd ${PWD}/docker/grafana; docker-compose down;
	@cd ${PWD}

start-services: kafka-start elk-start grafana-start postgres-start ## Starts all dockerized services

stop-services: postgres-stop grafana-stop elk-stop kafka-stop ## Stops all dockerized services

test: ## Runs the tests
	mvn test

container: clean build ## Builds the docker container for this project
	docker build -t wp-poc .

clean: ## Cleans the project
	mvn clean

help: ## Prints this help
	@echo 'Usage: make <target>'
	@echo ''
	@echo 'Valid targets:'
	@awk -F ':|##' '/^[^\t].+?:.*?##/ {\
	printf "\033[36m%-30s\033[0m %s\n", $$1, $$NF \
	}' $(MAKEFILE_LIST)
