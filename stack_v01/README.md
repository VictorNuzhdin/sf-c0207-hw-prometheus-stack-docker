# Docker Compose configuration v0.1
NodeExporter for Prometheus (collects Metrics from host)

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

curl -s http://127.0.0.1:9100 | grep "<title>"    ## <title>Node Exporter</title>

chrome: https:/srv.dotspace.ru/exporter           ## Prometheus Node Exporter (version=1.6.1)
chrome: https:/srv.dotspace.ru/exporter/metrics   ## Metrics collected from [srv.dotspace.ru] host

$ docker compose down                             ## stop and remove all Containers and and corresponding data Layers
```
