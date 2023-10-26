==CHANGES FROM PREVIOUS VERSION

--установка стека Grafana

8.1
    .env
    - добавлен блок "### Grafana" с необходимыми переменными окружения

8.2
    docker-compose.yaml
    - реализован блок "grafana" сервиса визуализации Метрик Grafana

8.3
    Grafana - настройка
    - после запуска стека вход в веб-интерфейс возможен по ендпоинту
      https://srv.dotspace.ru/mon/grafana
    - подключен источник данных "Prometheus" [http://prometheus:9090] расположенный на этом-же сервере
      который поставляет Метрики "Node Exporter" и "Blackbox Exporter" для их визуализации в Grafana
    - создан Дашборд "sf-c0207-exporters-node-blackbox" и его Панели отображающие основные Метрики серверов
      1: https://srv.dotspace.ru        (отображаются "Node Exporter" + "Blackbox Exporter" Метрики)
      2: https://apps.skillfactory.ru   (отображаются "Blackbox Exporter" Метрики)
    - дашборд доступен по URL
      https://srv.dotspace.ru/mon/grafana/d/customsfc/sf-c0207-exporters-node-blackbox?orgId=1&refresh=30s
