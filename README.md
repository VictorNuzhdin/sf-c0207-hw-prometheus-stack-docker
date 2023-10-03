# sf-c0207-hw-prometheus-stack-docker
For Skill Factory study project (C02, HW)

<br>


### Quick Info

```bash
Docker Compose stack with these services:
* NodeExporter for Prometheus
* Prometheus
```

### Quick UserGuide

```bash
$ docker --version                                   ## Docker version 24.0.6, build ed223bc
$ docker compose version                             ## Docker Compose version v2.22.0

$ cd stack_v02                                       ## select configurations implementation

$ docker compose up -d                               ## build and run all Containers

$ docker images                                      ## show created Images
$ docker ps                                          ## show running Containers (except stopped)
$ docker ps -a                                       ## show all Containers (even stopped)

$ curl -s http://127.0.0.1:9100 | grep "<title>"     ## <title>Node Exporter</title>
$ curl -s http://127.0.0.1:9090                      ## <a href="/mon/prom/graph">Found</a>.

browser:
    https:/srv.dotspace.ru
    >7. Prom :: NodeExporter
        https:/srv.dotspace.ru/mon/exporter          ## Prometheus Node Exporter (version=1.6.1)
        https:/srv.dotspace.ru/mon/exporter/metrics  ## metrics collected from [srv.dotspace.ru] server

    > 8. Prom :: Prometheus
         https:/srv.dotspace.ru/mon/prom             ## Prometheus Time Series Collection and Processing Server


$ docker compose down                                ## stop and remove all Containers and and corresponding data Layers
```

### Changelog (newest first)

```bash
2023.10.03 :: Docker Compose Stack v0.2 implemented
2023.10.02 :: Docker Compose Stack v0.1 implemented
```

### Results

Screen01: Root website HomePage <br>
![screen](../_screens/stack_v02/screen_0_0__rootSite.png?raw=true)
<br>

Screen02: Endpoint 1 (NodeExporter) access restrictions <br>
![screen](../_screens/stack_v02/screen_1_1__basicAuh__node-exporter.png?raw=true)

Screen03: Endpoint 1 (NodeExporter) access granted <br>
![screen](../_screens/stack_v02/screen_1_2__node-exporter.png?raw=true)
<br>

Screen04: Endpoint 2 (Prometheus) access granted <br>
![screen](../_screens/stack_v02/screen_2_2__prometheus.png?raw=true)
<br>

----
