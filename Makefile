SHELL = /bin/sh
include ./docker/.env
export

build_all: build_post build_comment build_ui build_prometheus

build_comment:
	cd ./src/comment && bash ./docker_build.sh

build_post:
	cd ./src/post-py && bash ./docker_build.sh

build_ui:
	cd ./src/ui && bash ./docker_build.sh

build_prometheus:
	cd ./monitoring/prometheus && docker build -f Dockerfile -t $(USER_NAME)/prometheus .

push_all: push_comment push_post push_ui push_prometheus

push_comment:
	docker push $(USER_NAME)/comment:latest

push_post:
	docker push ${USER_NAME}/post:latest

push_ui:
	docker push ${USER_NAME}/ui:latest

push_prometheus:
	docker push ${USER_NAME}/prometheus:latest

up:
	cd ./docker && docker-compose -f docker-compose.yml up -d

down:
	cd ./docker && docker-compose down

du:
	cd ./docker && docker-compose down && docker-compose  -f docker-compose.yml  stop

killall:
	yc compute instance delete docker-host
	docker-machine rm docker-host
