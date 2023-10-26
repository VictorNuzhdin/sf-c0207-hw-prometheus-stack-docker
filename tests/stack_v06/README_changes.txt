==CHANGES FROM PREVIOUS VERSION

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


##
##=Example Email && Telegram Message :: host_memory_low_{1,2}
##
##  --When FIRING
##
##        🔥FIRING🔥
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
##  --When RESOLVED
##
##        ✅RESOLVED✅
##
##        host_memory_low_{1,2}
##        Node: [srv.dotspace.ru]
##        Severity: critical
##
##        Message:
##        Critical: Memory space is full (>90%)
##        From: [host2.dotspace.ru:9100] :: Current Mem usage: 97.32%
##
##        Check for details:
##        targets (https://srv.dotspace.ru/mon/prom/targets?search=node-exporter),
##        alerts (https://srv.dotspace.ru/mon/alerter/#/alerts)
##

##
##=Example Email && Telegram Message :: PrometheusTargetMissing
## 
##  --When FIRING
##
##        🔥 FIRING 🔥
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
##  --When RESOLVED
##
##        ✅RESOLVED✅
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
