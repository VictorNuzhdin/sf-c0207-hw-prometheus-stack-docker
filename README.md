# sf-c0207-hw-prometheus-stack-docker
For Skill Factory study project (C02, HW) <br>
Node Exporter, Blackbox Exporter, Prometheus, Alertmanager, cAdvisor, Portainer, Grafana

<br>


### Quick Info

```bash
Docker-Compose стек включающий следующие Docker-Cервисы размещенные за обратным прокси Nginx (шлюз доступа):

   =Сервис                                Внешний URL                                   Внутренний URL

    Prometheus                            https://srv.dotspace.ru/mon/prom/             http://127.0.0.1:9090/
    Prometheus Node Exporter              https://srv.dotspace.ru/mon/exporter/         http://127.0.0.1:9100/
    Prometheus Blackbox Exporter          https://srv.dotspace.ru/mon/blackbox/         http://127.0.0.1:9115/
    Prometheus Alert Manager              https://srv.dotspace.ru/mon/alerter/          http://127.0.0.1:9093/
  
    cAdvisor                              https://srv.dotspace.ru/mon/cadv/containers/  http://127.0.0.1:8088/
    Portainer                             https://srv.dotspace.ru/mon/port/#!/home      http://127.0.0.1:9000/
    Grafana                               https://srv.dotspace.ru/mon/grafana           http://127.0.0.1:3000/

Кроме того, доступны следующие URL хостов входящих в кластер Мониторинга:

                                          Внешний URL                                   Внутренний URL
    srv..: Dockerized веб-приложение 1    https://srv.dotspace.ru/apps/app01/           http://127.0.0.1:8001/
    srv..: Dockerized веб-приложение 2    https://srv.dotspace.ru/apps/app02/           http://127.0.0.1:8002/

    host1: Домашняя страница              http://host1.dotspace.ru/                     http://127.0.0.1:80/
    host1: Dockerized веб-приложение      http://host1.dotspace.ru:8001/                http://127.0.0.1:8001/

    host2: Домашняя страница              http://host2.dotspace.ru/                     http://127.0.0.1:80/
    host2: Dockerized веб-приложение      http://host2.dotspace.ru:8001/                http://127.0.0.1:8001/

Структура каталогов Проекта:

    _helpers  :: разные подсказки
    _screens  :: скриншоты этапов разработки
    _scripts  :: различные инструментальные скрипты
    _secrets  :: каталог с данными авторизации (исключен)
    tests     :: тестовые рабочие каталоги с разными версиями стека
    current   :: текущий рабочий каталог (последняя версия из tests)

```
<br>

### Quick UserGuide

```bash
#00
..проверяем текущие версии зависимостей

  $ docker --version          ## Docker version 24.0.6, build ed223bc
  $ docker compose version    ## Docker Compose version v2.22.0

..устанавливаем необходимые для работы секреты (обязательно)

$ mkdir _secrets
$ nano _secrets/.env

    TELEGRAM_ADMIN='<ВАШ_TELEGRAM_ID_КАНАЛА_БОТА>'
    TELEGRAM_TOKEN='<ВАШ_HTTP_API_ТОКЕН_АВТОРИЗАЦИИ>'
    GMAIL_LOGIN='<ВАШ_GMAIL_АДРЕС_ЭЛПОЧТЫ_ДЛЯ_ОПОВЕЩЕНИЙ>'
    GMAIL_APPWD='<ВАШ_GMAIL_2Ф_ПАРОЛЬ_ПРИЛОЖЕНИЯ_ДЛЯ_АВТОРИЗАЦИИ>'

$ nano _secrets/sec_smtp_pwd

    '<ВАШ_GMAIL_2Ф_ПАРОЛЬ_ПРИЛОЖЕНИЯ_ДЛЯ_АВТОРИЗАЦИИ>'

$ nano _secrets/sec_tg_id.txt

    '<ВАШ_TELEGRAM_ID_КАНАЛА_БОТА>'

$ nano _secrets/sec_tg_token.txt

    '<ВАШ_HTTP_API_ТОКЕН_АВТОРИЗАЦИИ>'

..перед запуском стека в текущем окружении, импортируем секреты в переменные окружения

$ export TELEGRAM_ADMIN=$(cat _secrets/sec_tg_id.txt) && echo $TELEGRAM_ADMIN
$ export TELEGRAM_TOKEN=$(cat _secrets/sec_tg_token.txt) && echo $TELEGRAM_TOKEN
$ source _secrets/.env


#01
..работа с кодом производится с помощью IDE "VSCode" в каталоге текущей версии стека в каталоге "tests":

  $ cd ./tests/stack_v08

#02
..в другом экземляре IDE производится запуск и контроль работы стека в каталоге "current"
  при этом необходимо выполнить скрипт синхронизирующий содержимое каталога "current" с "tests/stack_v<НОМЕР_ВЕРСИИ>":

  $ cd ./current
  $ ../_scripts/updateCurrent.sh v08
  ..или (если есть проблемы с правами при удаление файлов)
  $ sudo ../_scripts/updateCurrent.sh v08

#03
..в результате будет уничтожен текущий стек и запущен новый из "docker-compose.yaml"
  и на экран будет выведена информация о работающий Контейнерах:

      --STEP0: Stopping current DockerCompose Stack..
      [+] Running 9/9
       ✔ Container blackbox-exporter  Removed                                                                                                                                                              0.9s 
       ✔ Container portainer          Removed                                                                                                                                                              0.6s 
       ✔ Container grafana            Removed                                                                                                                                                              0.5s 
       ✔ Container alertmanager       Removed                                                                                                                                                              0.9s 
       ✔ Container prometheus         Removed                                                                                                                                                              0.5s 
       ✔ Container node-exporter      Removed                                                                                                                                                              0.7s 
       ✔ Container cadvisor           Removed                                                                                                                                                              0.9s 
       ✔ Container redis              Removed                                                                                                                                                              0.7s 
       ✔ Network current_default      Removed                                                                                                                                                              0.2s 

      --STEP1: Copying new DockerCompose configs and Starting NEW Stack..
      tests/stack_v08

      ../current/
      ├── alertmanager
      ├── blackbox
      ├── grafana
      ├── hosts
      ├── prometheus
      ├── docker-compose.yaml
      ├── README_changes.txt
      └── README.md

      5 directories, 3 files

      --STEP2: Checking running NEW Stack Containers..

      [+] Running 9/9
       ✔ Network current_default      Created        0.1s 
       ✔ Container redis              Started        0.2s 
       ✔ Container portainer          Started        0.2s 
       ✔ Container node-exporter      Started        0.2s 
       ✔ Container blackbox-exporter  Started        0.2s 
       ✔ Container cadvisor           Started        0.1s 
       ✔ Container prometheus         Started        0.1s 
       ✔ Container grafana            Started        0.2s 
       ✔ Container alertmanager       Started        0.2s 

      CONTAINER ID   IMAGE                                  STATUS    PORTS                                         NAMES
      cc0d0bfc926f   grafana/grafana:10.1.5-ubuntu          Up        127.0.0.1:3000->3000/tcp                      grafana
      c955ca6bec01   prom/alertmanager:v0.26.0              Up        127.0.0.1:9093->9093/tcp                      alertmanager
      7d0035fb4b58   prom/prometheus:v2.47.2                Up        127.0.0.1:9090->9090/tcp                      prometheus
      753e2e7949bc   gcr.io/cadvisor/cadvisor:v0.46.0       Up        127.0.0.1:8088->8080/tcp                      cadvisor
      0df247ac3e22   portainer/portainer-ce:2.19.1-alpine   Up        8000/tcp, 9443/tcp, 0.0.0.0:9000->9000/tcp    portainer
      e0ffe26a0405   prom/blackbox-exporter:v0.23.0         Up        127.0.0.1:9115->9115/tcp                      blackbox-exporter
      0f614003bb9f   redis:7.2.1-alpine                     Up        127.0.0.1:6379->6379/tcp                      redis
      1229a65cb115   prom/node-exporter:v1.6.1              Up        127.0.0.1:9100->9100/tcp                      node-exporter
      f0ffdc72afbd   webapps-webapp1                        Up        0.0.0.0:8001->8000/tcp                        webapp1
      c26d86302a7b   webapps-webapp2                        Up        0.0.0.0:8002->8000/tcp                        webapp2

#04
..проверяем текущие Docker Образы

  $ docker images

      REPOSITORY                 TAG             IMAGE ID       CREATED         SIZE
      webapps-webapp2            latest          4ff7f64656f6   8 days ago      60.6MB
      webapps-webapp1            latest          8fb2daf8529e   8 days ago      60.6MB
      prom/prometheus            v2.47.2         22010d1e5539   13 days ago     245MB
      grafana/grafana            10.1.5-ubuntu   139fe28a30cc   2 weeks ago     456MB
      portainer/portainer-ce     2.19.1-alpine   441977f48c46   5 weeks ago     301MB
      redis                      7.2.1-alpine    2d5230e57b1b   7 weeks ago     37.8MB
      prom/alertmanager          v0.26.0         9f27df16978d   2 months ago    66.8MB
      prom/node-exporter         v1.6.1          458e026e6aa6   3 months ago    22.8MB
      prom/blackbox-exporter     v0.23.0         caf8d97eed98   10 months ago   23.6MB
      gcr.io/cadvisor/cadvisor   v0.46.0         78367b75ee31   11 months ago   83.1MB

..проверяем текущие Docker Разделы для обеспечения сохранности данных после уничтожения Контейнеров

  $ docker volume list

      DRIVER    VOLUME NAME
      local     current_vol-prometheus
      local     current_vol-alertmanager
      local     current_vol-redis
      local     current_vol-portainer
      local     current_vol-grafana

  $ sudo ls /var/lib/docker/volumes/current_vol-prometheus/_data/data
  $ sudo ls /var/lib/docker/volumes/current_vol-alertmanager/_data/data
  $ sudo ls /var/lib/docker/volumes/current_vol-grafana/_data
  $ sudo ls /var/lib/docker/volumes/current_vol-grafana/_data/grafana.db   ## БД Grafana которая хранит конфигурацию и накопленные данные Метрик

  (i) остальные разделы не представляют интереса т.к в них нет критичных данных которые необходимо сохранять
      они созданы только для общего порядка

#05
..если необходимо остановить, запустить, поставить на паузу или снять с паузы текущий стек и прочие команды

  $ cd ./current

  $ docker compose down
  $ docker compose up -d

  $ docker compose stop
  $ docker compose start

  $ docker compose pause <имя_контейнера>
  $ docker compose unpause <имя_контейнера>

  $ docker images
  $ docker ps
  $ docker ps -a

#06
..после успешного запуска всех контейнеров проверяем доступные внешние ендпоинтыс помощью Браузера на внешнем Хосте

  http://host1.dotspace.ru/    ## домашняя страница наблюдаемого Хоста1
  http://host2.dotspace.ru/    ## домашняя страница наблюдаемого Хоста2

  https://srv.dotspace.ru/     ## домашняя страница Сервера мониторинга со ссылками на Сервисы и Хосты
                               ## с этой страницы можно перейти на другие сервисы стека

  + результат работы всех сервисов см. на скриншотах ниже

```
<br>

### Changelog

```bash
2023.10.03 :: Docker Compose Stack v0.2 implemented
2023.10.02 :: Docker Compose Stack v0.1 implemented

#stack_v00
0.1
    Initial Docker Compose Stack for testing with example web page

#stack_v01
1.1
    Docker Compose "Node Exporter" Service implemented

#stack_v02
2.1
    Docker Compose "Node Exporter" and "Prometheus" Services implemented

#stack_v03
3.1
    Added Services: "cadvisor" and "redis" as dependency
    https://github.com/lucperkins/prometheus-playground-old/blob/master/cadvisor/docker-compose.yml

3.2
    Fixed "cadvisor" container start-time bugs

3.3
    Added Services: "portainer"
	
#stack_v04
4.1
    .env
    - all sensitive DockerCompose coniguration variables now here
4.2
    docker-compose.yaml
    - removed all commented test blocks
4.3
    prometheus/prometheus.yaml
    - removed all commented test blocks
4.4
    prometheus/alert.rules
    - removed all commented test blocks
4.5
    alertmanager/_templates/email.tmpl
    - created message-template file for gmail notification
      https://velenux.wordpress.com/2021/04/23/how-to-change-prometheus-alertmanager-e-mail-template/
      https://raw.githubusercontent.com/prometheus/alertmanager/master/template/default.tmpl
      https://prometheus.io/docs/alerting/latest/configuration/#email_config
      https://prometheus.io/blog/2016/03/03/custom-alertmanager-templates/
      https://prometheus.io/docs/alerting/latest/notifications/
4.6
    alertmanager/alertmanager.yaml
    - removed all commented test blocks
    - added custom email message template
4.7
    alertmanager/alertmanager.yaml
    - implement multi-routing (sendings Alerts to Telegram + Gmail at once)

#stack_v05
5.1
    prometheus/node.rules
    - переименован и перенесен в
      prometheus/rules/target.rules
      в этой конфигурации будут только алерты связанные с UP/DOWN статусами сервисов
5.2
    prometheus/rules/target.rules
    - создано несколько вариантов алертов (v1..v4)
      в последнем из которых формируется 3 вида Алерта
      * PrometheusTargetMissing - срабатывает при переходе любого сервиса в DOWN с пометкой "critical"
      * NodeHPServiceDown       - срабатывает при переходе любого сервиса с высоким приоритетом в DOWN (node-exporter)
      * NodeLPServiceDown       - срабатывает при переходе любого сервиса с низким приоритетом в DOWN  (cadvisor)
5.3
    prometheus/rules/node.rules
    - создана новая конфигурация
      в этой конфигурации будут алетры связанные с различныи значениями основных метрик Сервера на котором работает Prometheus
      которые собираются с помощью сервиса "node-exporter" (основной сервис сбора метрик с Сервера)
5.4
    alertmanager/alertmanager.yaml
    - настроены маршруты для отправки алетртов таким оразом что:
      1. алерты "PrometheusTargetMissing" (critical) отправляются на резервный адрес эл.почты <nuzhdin.vicx@yandex.ru>
      2. алерты "NodeLPServiceDown"       (low)      отправляются на основной  адрес эл.почты <devops.dotspace@gmail.com>
      3. алерты "NodeHPServiceDown"       (critical) отправляются в Telegram канал чат-бота
      4. все остальные алерты явно не прописанные в правилах маршрутизации отправляются в Telegram канал (маршрут по-умолчанию)
5.5
    prometheus/prometheus.yaml
    - внесены соотв. изменения в блок "rule_files":
        - "rules/target.rules"
        - "rules/node.rules"
5.6
    alertmanager/alertmanager.yaml
    - создан блок "time_intervals" временных диапазонов для ограничения срабатывания алертов:
      * time2die - алерты срабатывают всегда (в рабочие дни и выходные) :: понедельник-воскресенье, с 00:01 по 23:59
      * time2work - алерты срабатывают только в рабочее время :: понедельник-пятница с 09:00 по 17:00
      * time2life - алерты срабатывают только в выходные дни  :: пятница-воскреснье с 17:01 по 23:59
    - в блоке "routes" для "ресиверов" добавлен блок "active_time_intervals"
      который определяет когда именно будут отправляться оповещения конкретным ресиверам:
      1. на почту YandexMail отправляются все   "critical" оповещения "PrometheusTargetMissing" всегда          (time2die)
      2. на почту GoogleMail отправляются все   "low"      оповещения "NodeLPServiceDown"       в рабочее время (time2work)
      3. в канал Telegram чат-бота отправляются "low"      оповещения "NodeLPServiceDown"       по выходным     (time2life)

#stack_v06
6.1
    prometheus/rules/not_tested/
    - добавлен каталог с примерами алертов часть из которых необходимо протестировать и взять себе в работу
      * containers.rules
      * hosts_rules.yaml

6.2
    prometheus/rules/*.*
    - файл "target.rules" переименован в "rules_targets.yaml"
    - файл "node.rules" переименован в "rules_node.yaml"
    * это выполнено чтобы привести имена фалов к единому образцу и чтобы они красиво сортировались по имени
      кроме того это не .rules формат, а yaml формат, поэтому им добавлено правильное расшерение
      которое не влияет на обработку файлов, но влияет на удобство работы в IDE (формата "rules" не существует и он не распознается

6.3
    созданы файлы конфигураций правил оповещения в которые будут помещаться протестированные правила из [01]
    - prometheus/rules/rules_targets.yaml
    - prometheus/rules/rules_node.yaml
    - prometheus/rules/rules_containers.yaml
    - prometheus/rules/rules_hosts.yaml

6.4
    prometheus/prometheus.yaml
    - внесены соотв. изменения в блок "rule_files":
        - "rules/rules_targets.yaml"     (правила для мониторинга Целевых сервисов на текущем Сервере/Ноде на котором расположен NodeExporter + Prometheus + AlertManager и прочее)
        - "rules/rules_node.yaml"        (правила для мониторинга самой Ноды с помощью основных метрик NodeExporter)
        - "rules/rules_hosts.yaml"       (правила для прочих серверов testing|staging|production и обычных хостов с помощью основных метрик NodeExporter)
        - "rules/rules_containers.yaml"  (правила для мониторинга Docker контейнеров на серверах и хостах чтобы отслеживать состояние (UP/DOWN) контейнеров dockerized приложений)
    
    - файлы "rules/rules_targets.yaml" и "rules/rules_node.yaml" вносят путанницу
      т.к по сути это обе конфигурации для Prometheus Ноды, 
      поэтому был оставлен один "rules/rules_node.yaml"
      с содержимым "rules/rules_targets.yaml"

6.5
    prometheus/rules/rules_node.yaml
    - было удалено правило алерта "PrometheusTargetMissing"
      т.к в моей конфигурации реализовано разделение на оповещения для сервисов с Высоким и Низким приоритетом
      и соответствующая маршрутизация Алертов на разные Ресиверы
      а срабатывание правила "PrometheusTargetMissing" приводит к дублированию информации в сообщениях отправляемых Ресиверам
      т.е приходит оповещение что один из Таргетов упал и этоже сообщение что упал сервис с Высоким или Низким приоритетом
      т.к это одни и теже сервисы
    - имя для правила изменено
      с  "name: target.rules"
      на "name: node.rules"

6.6
    alertmanager/alertmanager.yaml
    - изменена маршрутизация для алертов с учетом того что было удалено правило "PrometheusTargetMissing"
      * теперь:
        - оповещения для HighPriority сервисов отправляются в Telegram канал чат-бота
        - оповещения для LowPriority  сервисов отправляются на резервный Email <nuzhdin.vicx@yandex.ru>
        - оповещения для HighPriority + LowPriority сервисов отправляются на основной Email <devops.dotspace@gmail.com>
    - применен новый синтаксис "matchers" с поддержкой регулярных выражений для создания правил с несколькими условиями срабатывания
      https://prometheus.io/docs/alerting/latest/configuration/#matcher
      * пример:
            matchers:
              - alertname =~ "NodeHPServiceDown|NodeLPServiceDown"
              - severity =~ "critical|low"

6.7
    prometheus/prometheus.yaml
    - подключена конфигурация с правилами Алертов для хостов "host1", "host2" 
      с которых собираются метрики с помощью развернутого на них сервиса "NodeExporter"
      http://host1.dotspace.ru:9100/metrics
      http://host2.dotspace.ru:9100/metrics

      ---prometheus.yaml
            ..
                rule_files:
                - "rules/rules_node.yaml"
                - "rules/rules_hosts.yaml"
            ..
6.8
    prometheus/rules/rules_hosts.yaml
    - по взятым за основу примерам:
      https://kamaok.org.ua/?p=3332
      https://samber.github.io/awesome-prometheus-alerts/rules.html
      https://www.dmosk.ru/miniinstruktions.php?mini=prometheus-stack-docker

    - реализована логика Алертов:
      * host_exporter_not_available
      * host_cpu_usage_high
      * host_disk_space_low
      * host_swap_usage_high  (не тестировалось т.к на хостах не настроен Swap)
      * host_memory_space_low (еще пока не реализовано)

#stack_v07
7.1.1
    prometheus/prometheus.yaml
    - добавлен маркер текущего сервера мониторинга/ноды, 
      чтобы можно было понимать от какого сервера с Prometheus стеком приходят оповещения

                global:
                external_labels:
                    monitoringNode: "srv.dotspace.ru"

    - теперь этот маркер можно использовать в шаблонах сообщений для подстановки например доменного имени сервера мониторнинга:

            --email.tmpl :: до - значение указано явно

                {{- if .Labels.instance }}
                <b>Node:</b> srv.dotspace.ru<br/>
                {{- end }}

            --email.tmpl :: после - значение подставляется

                {{- if .Labels.monitoringNode }}
                <b>Node: </b>[{{ .Labels.monitoringNode }}]
                {{- end }}


            --telegram.tmpl :: до - значение указано явно

                {{- if .Labels.instance }}
                <b>Node:</b> [srv.dotspace.ru]
                {{- end }}

            --telegram.tmpl :: после - значение подставляется

                {{- if .Labels.monitoringNode }}
                <b>Node: </b>[{{ .Labels.monitmonitoringNodeor }}]
                {{- end }}


7.2.1 :: реализация сборки метрик с помощью Prometheus "Blackbox Exporter"

    docker-compose.yaml
    - добавлен сервис "Prometheus Blackbox Exporter" (blackbox-exporter) -- Prober exporter for Prometheus
      https://hub.docker.com/r/prom/blackbox-exporter/
      https://hub.docker.com/r/prom/blackbox-exporter/tags
      * docker pull prom/blackbox-exporter:latest
      * docker pull prom/blackbox-exporter:v0.23.0

      - примеры конфигураций "Blackbox Exporter":
        https://github.com/prometheus/blackbox_exporter
        https://www.dmosk.ru/miniinstruktions.php?mini=prometheus-stack-docker#blackbox
        https://github.com/lucperkins/prometheus-playground-old/blob/master/blackbox-exporter/README.md
        https://samber.github.io/awesome-prometheus-alerts/rules.html#blackbox

7.2.2
    prometheus/prometheus.yaml
    - добавлен блок подключающий "BlackboxExporter" к Prometheus
      и создающий новую Задачу для проверки доступности хостов "host1", "host2" по HTTP

7.2.3
    blackbox/blackbox.yaml
    - добавлена конфигурация "Blackbox Exporter"

7.2.4
    prometheus/prometheus.yaml
    - подключена конфигурация с правилами Алертов
            ..
                rule_files:
                - "rules/rules_node.yaml"
                - "rules/rules_hosts.yaml"
                - "rules/rules_blackbox.yaml"
            ..

    - добавлены сайты в качестве Таргетов для BlackboxExporter состояние которых будет отслеживаться
      *таргеты тестировались поочереди, т.к подключение всех сразу приводит к очень "шумной" работе системы оповещения
            ..
                static_configs:
                    - targets:
                    - https://srv.dotspace.ru
                    - https://apps.skillfactory.ru
                    #- https://dotspace.ru
                    #- https://srv.dotspace.ru
                    #- http://host1.dotspace.ru
                    #- http://host2.dotspace.ru
                    #- https://apps.skillfactory.ru
            ..

7.2.5
    prometheus/rules/rules_blackbox.yaml
    - создан файл конфигурации Алертов для Blackbox
    - добавлено правило "BlackboxProbeHttpFailure" Алерта проверяющего доступость хостов по HTTP/s с помощью "BlackboxExporter"
      https://dotspace.ru:9100/metrics
      http://host1.dotspace.ru:9100/metrics
      http://host2.dotspace.ru:9100/metrics
    - добавлены правила Алертов проверяющих срок действия сертификата и оповещающих о его истечении:
      * BlackboxSslCertificateWillExpireLess30
      * BlackboxSslCertificateWillExpireLess15
      * BlackboxSslCertificateWillExpireLess5
    - добавлено правило Алерта проверяющее перезагрузку вебсайта по метрике Uptime
      *в примере она называлась как Uptime как момент перезагрузился http сервис
       не совсем понятно почему за Uptime отвечает метрика "probe_success" (вроде она показывает факт того что все Blackbox метрики сняты успешно)

7.2.6
    prometheus/rules/rules_hosts.yaml
    - создано тестовое правило Алерта "host_uptime_10m" которое проверяет время работы сервера после перезагрузки и если оно больше 10 минут то оправляет уведомление
      это правило добавлено для тестирования отслеживания времени работы сервера
      в реальной работе оно возможно не понадобится, если только для уведомлений что сервер проработал, например, больше 12 часов
    - создано правило "host_uptime_12h" отправляющее оповещение если хост проработал более 12 часов
    - если необходима гибкая настройка роутинга/отправки подобного рода информационных оповещений,
      то в файле "alertmanager/alertmanager.yaml" необходимо создать соотвествующий маршрут
      например который будет отправлять подобные уведомления только определенным получателям
      и не отправлять сообщения вида "RESOLVED"..
      по хорошему, для INFO сообщений необходимо создать отдельный шаблон,
      чтобы в них НЕ было заголовка [🔥FIRING🔥]
      а был заголовок например [⚠️INFO⚠️] или [✳️INFO✳️] или [💬INFO💬] или [🔔INFO🔔]
    - идея озвученная выше реализована:
      * создан новый шаблон "alertmanager/_templates/telegram_info.tmpl"
      * в "alertmanager/alertmanager.yaml" добавлен новый маршрут и ресивер "tg-notifications-info" для INFO сообщений 
        с повторной отправкой каждые 12 часов и отключенными "RESOLVED" сообщениями

7.2.7
    проведено тестирование срабатывания Алертов связанных с истечением срока действия SSL/TLS сертификата
    для этого использовалось временное правило "BlackboxSslCertificateWillExpireLess60" (удалено после успешного тестирования)

#stack_v08 :: установка и настройка сервиса визуализации Метрик "Grafana"
8.1
    .env
    - добавлен блок "### Grafana" с необходимыми переменными окружения

8.2
    docker-compose.yaml
    - реализован блок "grafana" сервиса визуализации Метрик Grafana

8.3
    Grafana: настройка и создание Дашборда для визуализации NodeExporter и BlackboxExporter Метрик из Prometheus
    - после запуска стека вход в веб-интерфейс возможен по ендпоинту
      https://srv.dotspace.ru/mon/grafana
    - подключен источник данных "Prometheus" [http://prometheus:9090] расположенный на этом-же сервере
      который поставляет Метрики "Node Exporter" и "Blackbox Exporter" для их визуализации в Grafana
    - создан Дашборд "sf-c0207-exporters-node-blackbox" и его Панели отображающие основные Метрики серверов
      1: https://srv.dotspace.ru        (отображаются "Node Exporter" + "Blackbox Exporter" Метрики)
      2: https://apps.skillfactory.ru   (отображаются "Blackbox Exporter" Метрики)
    - дашборд доступен по URL
      https://srv.dotspace.ru/mon/grafana/d/customsfc/sf-c0207-exporters-node-blackbox?orgId=1&refresh=30s

```
<br>

### Results

Screen110: Сервер Мониторинга: Домашняя страница <br>
![screen](_screens/stack_v08/screen_1_0.png?raw=true)
<br>

Screen110: Хост1: Домашняя страница <br>
![screen](_screens/stack_v08/screen_1_1.png?raw=true)

Screen120: Хост2: Домашняя страница <br>
![screen](_screens/stack_v08/screen_1_2.png?raw=true)
<br>

Screen220: Portainer: Docker Images <br>
![screen](_screens/stack_v08/screen_2_2.png?raw=true)
<br>

Screen230: Portainer: Docker Containers <br>
![screen](_screens/stack_v08/screen_2_3.png?raw=true)
<br>

Screen310: CAdvisor: Мониторинг Docker окружения <br>
![screen](_screens/stack_v08/screen_3_1.png?raw=true)
<br>
![screen](_screens/stack_v08/screen_3_3.png?raw=true)
<br>
![screen](_screens/stack_v08/screen_3_4.png?raw=true)
<br>

Screen410: NodeExporter: Интерфейс и пример Метрик <br>
![screen](_screens/stack_v08/screen_4_0.png?raw=true)
<br>
![screen](_screens/stack_v08/screen_4_1.png?raw=true)
<br>

Screen510: BlackboxExporter: Пример Метрик <br>
![screen](_screens/stack_v08/screen_5_0.png?raw=true)
<br>
![screen](_screens/stack_v08/screen_5_3.png?raw=true)
<br>

Screen610: Prometheus: Сервисы и Таргеты <br>
![screen](_screens/stack_v08/screen_6_1.png?raw=true)
<br>
![screen](_screens/stack_v08/screen_6_2.png?raw=true)
<br>

Screen631: Prometheus: Правила Оповещений (Alert Rules) <br>
![screen](_screens/stack_v08/screen_6_3_1.png?raw=true)
<br>
![screen](_screens/stack_v08/screen_6_3_2.png?raw=true)
<br>
![screen](_screens/stack_v08/screen_6_3_3.png?raw=true)
<br>

Screen641: Prometheus: Состояние Оповещений (Alerts State) <br>
![screen](_screens/stack_v08/screen_6_4_1.png?raw=true)
<br>
![screen](_screens/stack_v08/screen_6_4_2.png?raw=true)
<br>
![screen](_screens/stack_v08/screen_6_4_3.png?raw=true)
<br>

Screen710: Тестирование(1.1): Контейнеры остановлены (сервисы упали) <br>
![screen](_screens/stack_v08/screen_7_1_0.png?raw=true)
<br>

Screen711: Тестирование(1.2): Правила Алертов активированы <br>
![screen](_screens/stack_v08/screen_7_1_1.png?raw=true)
<br>

Screen713: Тестирование(1.3): Алерты пришли в AlertManager и отправлены Ресиверам <br>
![screen](_screens/stack_v08/screen_7_1_3.png?raw=true)
<br>

Screen714: Тестирование(1.4): Пришло оповещение в Telegram канал <br>
![screen](_screens/stack_v08/screen_7_1_4.png?raw=true)
<br>

Screen715: Тестирование(1.5): Пришло оповещение на Gmail почту <br>
![screen](_screens/stack_v08/screen_7_1_5.png?raw=true)
<br>

Screen716: Тестирование(1.6): Пришло оповещение на Yandex почту <br>
![screen](_screens/stack_v08/screen_7_1_6.png?raw=true)
<br>

Screen720: Тестирование(2.1): Контейнеры запущены (сервисы восстановлены) <br>
![screen](_screens/stack_v08/screen_7_2_0.png?raw=true)
<br>

Screen721: Тестирование(2.2): Правила Алертов деактивированы <br>
![screen](_screens/stack_v08/screen_7_2_1.png?raw=true)
<br>

Screen722: Тестирование(2.3): В AlertManager нет активных задач отправки уведомлений<br>
![screen](_screens/stack_v08/screen_7_2_2.png?raw=true)
<br>

Screen723: Тестирование(2.4): Пришло оповещение в Telegram канал<br>
![screen](_screens/stack_v08/screen_7_2_3.png?raw=true)
<br>

Screen724: Тестирование(2.5): Пришло оповещение на Gmail почту<br>
![screen](_screens/stack_v08/screen_7_2_4.png?raw=true)
<br>

Screen725: Тестирование(2.6): Пришло оповещение на Yandex почту<br>
![screen](_screens/stack_v08/screen_7_2_5.png?raw=true)
<br>

Screen810: Grafana: Мониторинг NodeExporter Метрик для Хоста [https://srv.dotspace.ru] <br>
![screen](_screens/stack_v08/screen_8_1.png?raw=true)
<br>

Screen820: Grafana: мониторинг BlackboxExporter Метрик для Хоста [https://apps.skillfactory.ru] <br>
![screen](_screens/stack_v08/screen_8_2.png?raw=true)
<br>

[>>Все скриншоты](_screens/stack_v08)
<br>

----
