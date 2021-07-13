SHELL = /bin/sh
include ./docker/.env
export

build_all: build_post build_comment build_ui build_prometheus build_alertmanager

build_comment:
	cd ./src/comment && bash ./docker_build.sh

build_post:
	cd ./src/post-py && bash ./docker_build.sh

build_ui:
	cd ./src/ui && bash ./docker_build.sh

build_alertmanager:
	cd ./monitoring/alertmanager && docker build -f Dockerfile -t $(USER_NAME)/alertmanager .

build_prometheus:
	cd ./monitoring/prometheus && docker build -f Dockerfile -t $(USER_NAME)/prometheus .

push_all: push_comment push_post push_ui push_prometheus push_alertmanager

push_comment:
	docker push $(USER_NAME)/comment:latest

push_post:
	docker push ${USER_NAME}/post:latest

push_ui:
	docker push ${USER_NAME}/ui:latest

push_prometheus:
	docker push ${USER_NAME}/prometheus:latest

push_alertmanager:
	docker push ${USER_NAME}/alertmanager:latest

up:
	cd ./docker && docker-compose -f docker-compose.yml up -d

down:
	cd ./docker && docker-compose down

du:
	cd ./docker && docker-compose down && docker-compose -f docker-compose.yml up -d

mon_du: mon_down mon_up

mon_up:
	cd ./docker && docker-compose -f docker-compose-monitoring.yml up -d

mon_down:
	cd ./docker && docker-compose -f docker-compose-monitoring.yml down

killall:
	yc compute instance delete docker-host
	docker-machine rm docker-host
