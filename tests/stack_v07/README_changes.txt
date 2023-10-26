==CHANGES FROM PREVIOUS VERSION

--разное

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


--реализация сборки метрик с помощью "Prometheus "Blackbox Exporter"

7.2.1
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


##
##=Telegram Message :: host_uptime_12h
##
##  --When FIRING
##
##        🔔INFO🔔
##
##        host_uptime_12h
##        Node: [srv.dotspace.ru]
##        Severity: info
##
##        Message:
##        From: [host1.dotspace.ru:9100]
##        Host uptime more than 12 hours
##        Current uptime: 13 hours
##
##        Check for details:
##        targets (https://srv.dotspace.ru/mon/prom/targets)
##

##
##=Example Email && Telegram Message :: BlackboxProbeDownMore5m
##
##  --When FIRING | RESOLVED
##
##        🔥FIRING🔥 | ✅RESOLVED✅
##
##        BlackboxProbeDownMore5m
##        Node: [srv.dotspace.ru]
##        Severity: critical
##
##        Message:
##        From: [http://host1.dotspace.ru]
##        Host http/s probe is LOST
##        Host probe is unavailable for more than 5 minutes
##
##        Check for details:
##        targets (https://srv.dotspace.ru/mon/prom/targets?search=exporter-blackbox),
##        alerts (https://srv.dotspace.ru/mon/alerter/#/alerts)
##

##
##=Example Email && Telegram Message :: host_memory_low_{1,2}
##
##  --When FIRING | RESOLVED
##
##        🔥FIRING🔥 | ✅RESOLVED✅
##
##         host_memory_low_{1,2}
##         Node: [srv.dotspace.ru]
##         Severity: critical
##
##         Message:
##         Critical: Memory space is full (>90%)
##         From: [host2.dotspace.ru:9100] :: Current Mem usage: 96.94%
##
##         Check for details:
##         targets (https://srv.dotspace.ru/mon/prom/targets?search=node-exporter),
##         alerts (https://srv.dotspace.ru/mon/alerter/#/alerts)
##

##
##=Example Email && Telegram Message :: PrometheusTargetMissing
## 
##  --When FIRING | RESOLVED
##
##        🔥 FIRING 🔥 | ✅ RESOLVED ✅
##
##        PrometheusTargetMissing       | NodeLPServiceDown                 | NodeHPServiceDown
##        Host: [srv.dotspace.ru]
##        Severity: critical            | low                               | critical
##
##        Message:
##        One of Host Service is DOWN   | Low Priority Service is DOWN      | High Priority Service is DOWN
##        node-exporter:9100            | cadvisor:8080                     | node-exporter:9100
##
##        Check for details:
##        targets,                      ## https://srv.dotspace.ru/mon/prom/targets?search=node
##        alerts                        ## https://srv.dotspace.ru/mon/alerter/#/alerts
##
