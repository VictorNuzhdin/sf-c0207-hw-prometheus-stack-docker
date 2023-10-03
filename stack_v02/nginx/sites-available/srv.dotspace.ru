server {

    root /var/www/srv.dotspace.ru/html;
    index index.html;

    # server_name srv.dotspace.ru www.srv.dotspace.ru;
    server_name srv.dotspace.ru;

    location / {
        try_files $uri $uri/ =404;

        ## restrict access by ip-address :: if no acceess HTTP_ERROR "403 Forbidden" occures
        #satisfy all;
        #
        #..deny lan ip-address
        #deny  192.168.1.2;
        #
        #..allow lan ip-network
        #allow 192.168.1.1/24;
        #
        #..allow access from my or known public ip-address
        #allow 92.124.136.25;
        #allow 176.59.143.89;
        #
        #..allow loopback
        #allow 127.0.0.1;
        #..deny all by default
        #deny  all;

        ## restrict access with basic auth (username:password)
        #auth_basic "Restricted Content";
        #auth_basic_user_file /etc/nginx/.htpasswd;
    }

    ## Reverse-Proxy to internal Zabbix server/service
    location /zabbix/ {
        proxy_pass http://10.0.10.13:8080/;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection Upgrade;
        proxy_set_header Host $host;
    }

    ## Reverse-Proxy to internal Dockerized Service :: NodeExporter (endpoint1)
    location /mon/exporter/ {
        # restrict access with basic auth
        auth_basic "Restricted Content";
        auth_basic_user_file /etc/nginx/.htpasswd;
        #
        proxy_pass http://127.0.0.1:9100/;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection Upgrade;
        proxy_set_header Host $host;
    }


    ## Reverse-Proxy to internal Dockerized Service :: NodeExporter (endpoint2)
    location /mon/exporter/metrics {
        # restrict access with basic auth
        auth_basic "Restricted Content";
        auth_basic_user_file /etc/nginx/.htpasswd;
        #
        proxy_pass http://127.0.0.1:9100/mon/exporter/metrics;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection Upgrade;
        proxy_set_header Host $host;
    }

    ## Reverse-Proxy to internal Dockerized Service :: Prometheus
    location /mon/prom/ {
        # restrict access with basic auth
        auth_basic "Restricted Content";
        auth_basic_user_file /etc/nginx/.htpasswd;
        #
        proxy_pass http://127.0.0.1:9090/;
    }

    ## Reverse-Proxy to internal Dockerized wepapp#01
    location /apps/app01/ {
        #proxy_pass http://10.0.10.13:8001/;
        proxy_pass http://127.0.0.1:8001/;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection Upgrade;
        proxy_set_header Host $host;
    }

    ## Reverse-Proxy to internal Dockerized wepapp#02
    location /apps/app02/ {
        proxy_pass http://127.0.0.1:8002/;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection Upgrade;
        proxy_set_header Host $host;
    }

    ## Reverse-Proxy to internal Dockerized wepapp#03
    location /apps/app03/ {
        proxy_pass http://127.0.0.1:8003/;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection Upgrade;
        proxy_set_header Host $host;
    }

    ## Reverse-Proxy to internal Dockerized wepapp#04
    location /apps/app04/ {
        proxy_pass http://127.0.0.1:8004/;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection Upgrade;
        proxy_set_header Host $host;
    }

    ## Reverse-Proxy to internal Dockerized wepapp#05
    location /apps/app05/ {
        proxy_pass http://127.0.0.1:8005/;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection Upgrade;
        proxy_set_header Host $host;
    }


    ## HTTPS/SSL Configuration with "Lets Encrypt" and "certbot"
    listen 443 ssl; # managed by Certbot
    ssl_certificate /etc/letsencrypt/live/srv.dotspace.ru/fullchain.pem; # managed by Certbot
    ssl_certificate_key /etc/letsencrypt/live/srv.dotspace.ru/privkey.pem; # managed by Certbot
    include /etc/letsencrypt/options-ssl-nginx.conf; # managed by Certbot
    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem; # managed by Certbot

    ## Logging Configuration
    access_log    /var/log/nginx/srv_dotspace_ru.access.log;
    error_log     /var/log/nginx/srv_dotspace_ru.error.log;
}

server {
    if ($host = srv.dotspace.ru) {
        return 301 https://$host$request_uri;
    } # managed by Certbot

    listen 80 default_server;
    server_name srv.dotspace.ru;
    return 404; # managed by Certbot
}
