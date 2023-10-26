# Example Python Flask WebApp
Hello from Python/Flask app1 for [srv.dotspace.ru]

[IDEA: Compose sample application](https://github.com/docker/awesome-compose/tree/master/flask)

<br/>
### Quick Guide

```
#01. Deploy with docker compose

$ docker compose up -d


#02. Expected result 1 :: Docker Images and Containers

$ docker images

    ...

$ docker ps

    ...

$ docker compose ps

    ...


#03. Expected result 2 :: Running WebApp

curl -s http://srv.dotspace.ru:8001

    Hello from Python/Flask app1 for [srv.dotspace.ru]

browser: http://srv.dotspace.ru:8001

    Hello from Python/Flask app1 for [srv.dotspace.ru]


#04. Stop and remove the containers

$ docker compose down

```
