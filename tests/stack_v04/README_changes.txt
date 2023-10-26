==CHANGES FROM PREVIOUS VERSION

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


##
##=Example Email && Telegram Message
## 
##  --When FIRING
##
##        🔥 FIRING 🔥
##
##        PrometheusTargetMissing
##        Host: [srv.dotspace.ru]
##        Severity: critical
##
##        Message:
##        One of Host Service is DOWN
##        node-exporter:9100
##
##        Check for details:
##        targets,                ## https://srv.dotspace.ru/mon/prom/targets?search=node
##        alerts                  ## https://srv.dotspace.ru/mon/alerter/#/alerts
##
##  --When RESOLVED
##
##        ✅RESOLVED✅
##
##        PrometheusTargetMissing
##        Host: [srv.dotspace.ru]
##        Severity: critical
##
##        Message:
##        One of Host Service is DOWN
##        node-exporter:9100
##
##        Check for details:
##        targets,                ## https://srv.dotspace.ru/mon/prom/targets?search=node
##        alerts                  ## https://srv.dotspace.ru/mon/alerter/#/alerts
##
