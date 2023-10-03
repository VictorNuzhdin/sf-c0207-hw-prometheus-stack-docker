# Docker Compose configuration v0.2
NodeExporter for Prometheus, Prometheus

<br>

### Quick Info

```bash
1. Docker Compose binary (docker-compose) installed as Docker-plugin into ~/.docker/cli-plugins/
2. Current user must be a member of the "docker" group
```

### Quick UserGuide

```bash

$ docker --version                               ## Docker version 24.0.6, build ed223bc
$ docker compose version                         ## Docker Compose version v2.22.0

$ docker compose up -d                            ## build and run all Containers

$ docker images                                   ## show created Images
$ docker ps                                       ## show running Containers (except stopped)
$ docker ps -a                                    ## show all Containers (even stopped)

$ curl -s http://127.0.0.1:9100 | grep "<title>"  ## <title>Node Exporter</title>
$ curl -s http://127.0.0.1:9090                   ## <a href="/mon/prom/graph">Found</a>.

browser: 
    https:/srv.dotspace.ru/mon/exporter           ## Prometheus Node Exporter (version=1.6.1)
    https:/srv.dotspace.ru/mon/exporter/metrics   ## metrics collected from [srv.dotspace.ru] server
    https:/srv.dotspace.ru/mon/prom               ## Prometheus Time Series Collection and Processing Server


$ docker compose down                             ## stop and remove all Containers and and corresponding data Layers
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
