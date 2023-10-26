==CHANGES FROM PREVIOUS VERSION

3.1
    Added Services: "cadvisor" and "redis" as dependency
    https://github.com/lucperkins/prometheus-playground-old/blob/master/cadvisor/docker-compose.yml

3.2
    Fixed "cadvisor" container start-time bugs

3.3
    Added Services: "portainer"


=COMMENTS

1.
    выявлена особенность применения флагов ограничения ресурсов для контейнеров в Docker Compose v3+
    - примеры описания лимитов на создаваемые ресурсы
        *  mem_limit: 512m
        *  mem_reservation: 128M
        *  shm_size: 128M

    https://kamaok.org.ua/?p=3332
    - используется версия docker-compose 2.4, 
      чтобы применялись лимиты на ресурсы (если использовать версию 3),
      тогда файл "docker-compose.yml" необходимо запускать в docker swarm
