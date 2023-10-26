==CHANGES FROM PREVIOUS VERSION

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


##
##=Example Email && Telegram Message
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
