# matveevelli_microservices

##Домашняя работа №22

- Создал кластер minikube
- Поднял reddit в нем
- Создан кластер kubernetes в yc
- Поднят reddit в нем
- Поднят балансировщик для доступа по `external_ip`
- Создана конфигурация `/kubernetes/reddit/terraform/` для поднятия managed-кластера и 2 нод
- Создан манифест `/kubernetes/reddit/dashboard/` для включения dashboard,
командой `kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep otus-admin | awk '{print $1}')` получаем токен для сервис аккаунта `otus-admin`
командой `kubectl proxy` включаем прокси :D
дальше переходим по адресу `http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/`, в токен вставляем наш скопированный

##Домашняя работа №21

- Создал терраформом три ноды: мастер и два воркера
- Установил на них `docker, kubeadm, kubectl, kubelet`
- Инициализировал на мастере кластер `kubeadm init --pod-network-cidr=10.244.0.0/16`, создал токен `kubeadm token create --print-join-command`
- Создал директорию `$HOME/.kube/` скопировал в нее `/etc/kubernetes/admin.config` как `$HOME/.kube/config`
- `kubectl get nodes` выдал мастерноду
- Команду из `kubeadm token create --print-join-command` проделал на воркерах, кластер создался
- Установил `calico` на мастер `curl https://docs.projectcalico.org/manifests/calico.yaml -O`
- Отредактировал манифест, изменил в нем `CALICO_IPV4POOL_CIDR` на `value: "10.244.0.0/16"`
- Применил манифест на мастере `kubectl apply -f calico.yaml` -- все ноды стали Ready
- Добавил в репозиторий папки `/kubernetes/terraform` `/kubernetes/ansible`


##Домашняя работа №20

- Создал инфру с докер машиной и новыми образами с тегом `logging`
- Создал докер-композ для логгирования
- Создал докер образ для `fluentd` и конфиг файл `fluent.conf`
- Добавил в основной композ файл отправку логов в `fluentd`
- В `kibana` добавил индекс и проверил что все получает
- Поигрался с поиском в кибане
- Докрутил `fluentd` для получения адекватных логов
- Добавили Grok`и для форматирования логов
- В слайде 49/61 нет скриншота
- Добавил `Zipkin` в инфру, подключил к сетям, потыкал трейсы

###Домашняя работа №19

- Разделил файл docker-compose на reddit и monitoring, появился новый, `docker-compose-monitoring.yml`
- Поднята инфраструктура с cAdvisor, добавлены цели `cAdvisor` и `post` в prometheus
- Добавлена графана в компоуз, поднята
- Импортирован дашборд, создан новый
- В новый кастомный дашборд добавлены метрики, добавлена функция rate() для первого графика `rate(ui_request_count{http_status=~"^[23].*"}[1m])`
- Создан график с 95 процентилем HTTP запросов
- Экспортирован дашборд в папку `grafana/dashboards`
- Создан дашборд бизнес-метрик, добавлены графики, экспортирован в папку к остальным
- Создан докерфайл alertmanager'a, добавлен конфиг webhook'a, в prometheus добавил алертменеджер с конфигфайлом
- Остановлен контейнер `post` - алерт получен в слак
- Запушил в докерхаб образы `matveevelli/ui`, `matveevelli/comment`, `matveevelli/post`, `matveevelli/prometheus`, `matveevelli/alertmanager`
- Дополнен Makefile
- Запущены метрики докер-демона (которые в экспериментальном режиме)


###Домашняя работа №18

- Поднят докер с `prometheus` в яндекс.облаке
- Посмотрел базовые метрики prometheus через UI
- Посмотрел интерфейс с `targets`
- Посмотрел как выглядит вывод экспортера `/metrics`
- Создал докер образ prometheus с конфигом
- Изменил докер-композ `reddit` и добавил ендпоинты в `prometheus`
- Добавил `node-exporter` в композ, проверил что метрики видно
- Добавил в композ и prometheus.yml мониторинг `mongoDB` с помощью экспортера `image: bitnami/mongodb-exporter:0.20.6`
- Добавил blackbox-exporter для мониторинга comment, ui, post
- Создал Makefile
- Запушил в докерхаб образы `matveevelli/ui`, `matveevelli/comment`, `matveevelli/post`, `matveevelli/prometheus`

###Домашняя работа №16

- Создана ВМ в yc с docker-host
- Разница между выводом с none и host сетью в количестве адаптеров (в хост не только loopback)
- С `docker-machine ssh docker-host ifconfig` есть разница откуа запускается, в случае `docker run -ti --rm --network host joffotron/docker-net-tools -c ifconfig` - из контейнера, а `docker-machine ssh docker-host ifconfig` - с хоста
- Запущен 2-4 раза контейнер nginx с флагом -d, при docker ps показывает один запущенный, потому-что он уже запущен)
- При запуске с none сетью - дбавляются неймспейсы
- Создали docker-compose файл
- После запуска не создавались комментарии, не хватало алиасов к бд
- Добавлены сети back_net и front_net
- Добавлены переменные в .env файл
- Базовое имя проекта задается параметром `COMPOSE_PROJECT_NAME`
- В файле `docker-compose.override.yml` добавляем директивы в CMD вида `puma --debug -w 2`

###Домашняя работа №15

- Создана ВМ я yc с докер-хост
- Добавлены каталоги из архива reddit-microservices
- Созданы dockerfile для микросервисов
- Создана docker-bridge сеть
- Запущены контейнеры и проверена работоспособность
- Переименованы сетевые алиасы на reddit_post и reddit_comment, переопределение происходит через ENV переменные в docker run `docker run -d --network=reddit -p 9292:9292 --env POST_SERVICE_HOST=reddit_post --env COMMENT_SERVICE_HOST=reddit_comment matveevelli/ui:5.0`
- Улучшен образ микросервиса на основе alpine, 265MB
- Создан volume для mongodb

###Домашняя работа №14

- Установил docker, docker-compose, docker-machine
- Запустил первый контейнер
- Сохранил вывод команды docker images в файл dockermonolith/docker-1.log
- Сравнил вывод команд docker inspect <u_container_id> и docker inspect <u_image_id> и записали в файл - docker-1.log
- Инициализировал хост docker-machine в Yandex Cloud
- Собрали образ с приложением с помощью файлов Dockerfile, db_config, start.sh, mongod.conf
- Запустили контейнер, проверили результат работы приложения
- Зарегистрировался на Docker hub и запушил туда image
- Поигрался с "проверочными" командами
