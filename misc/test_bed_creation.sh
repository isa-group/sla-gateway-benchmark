# ( these should be run inside sla-gateway-benchmark/ )

######### Envoy

## Header

PROXY_CONF_FILE=proxy-configuration-envoy-header.yaml
CFG_PATH=/tmp/$PROXY_CONF_FILE docker-compose --file proxies/envoy/docker-compose-envoy.yaml down
node ../sla-wizard/src/index.js config envoy --oas specs/simple_api_oas.yaml --sla specs/slas/ --outFile /tmp/$PROXY_CONF_FILE
CFG_PATH=/tmp/$PROXY_CONF_FILE docker-compose --file proxies/envoy/docker-compose-envoy.yaml up #--build

## Query

PROXY_CONF_FILE=proxy-configuration-envoy-query.yaml
CFG_PATH=/tmp/$PROXY_CONF_FILE docker-compose --file proxies/envoy/docker-compose-envoy.yaml down
node ../sla-wizard/src/index.js config envoy --oas specs/simple_api_oas.yaml --sla specs/slas/ --outFile /tmp/$PROXY_CONF_FILE --authLocation query
CFG_PATH=/tmp/$PROXY_CONF_FILE docker-compose --file proxies/envoy/docker-compose-envoy.yaml up #--build

## Url

PROXY_CONF_FILE=proxy-configuration-envoy-url.yaml
CFG_PATH=/tmp/$PROXY_CONF_FILE docker-compose --file proxies/envoy/docker-compose-envoy.yaml down
node ../sla-wizard/src/index.js config envoy --oas specs/simple_api_oas.yaml --sla specs/slas/ --outFile /tmp/$PROXY_CONF_FILE --authLocation url
CFG_PATH=/tmp/$PROXY_CONF_FILE docker-compose --file proxies/envoy/docker-compose-envoy.yaml up #--build


######### HAProxy

## Header

PROXY_CONF_FILE=proxy-configuration-haproxy-header.cfg
CFG_PATH=/tmp/$PROXY_CONF_FILE docker-compose --file proxies/haproxy/docker-compose-haproxy.yaml down
node ../sla-wizard/src/index.js config haproxy --oas specs/simple_api_oas.yaml --sla specs/slas/ --outFile /tmp/$PROXY_CONF_FILE
CFG_PATH=/tmp/$PROXY_CONF_FILE docker-compose --file proxies/haproxy/docker-compose-haproxy.yaml up #--build

## Query

PROXY_CONF_FILE=proxy-configuration-haproxy-query.cfg
CFG_PATH=/tmp/$PROXY_CONF_FILE docker-compose --file proxies/haproxy/docker-compose-haproxy.yaml down
node ../sla-wizard/src/index.js config haproxy --oas specs/simple_api_oas.yaml --sla specs/slas/ --outFile /tmp/$PROXY_CONF_FILE --authLocation query
CFG_PATH=/tmp/$PROXY_CONF_FILE docker-compose --file proxies/haproxy/docker-compose-haproxy.yaml up #--build

## Url

PROXY_CONF_FILE=proxy-configuration-haproxy-url.cfg
CFG_PATH=/tmp/$PROXY_CONF_FILE docker-compose --file proxies/haproxy/docker-compose-haproxy.yaml down
node ../sla-wizard/src/index.js config haproxy --oas specs/simple_api_oas.yaml --sla specs/slas/ --outFile /tmp/$PROXY_CONF_FILE --authLocation url
CFG_PATH=/tmp/$PROXY_CONF_FILE docker-compose --file proxies/haproxy/docker-compose-haproxy.yaml up #--build


######### NGINX

## Header

PROXY_CONF_FILE=proxy-configuration-nginx-header.conf
CFG_PATH=/tmp/$PROXY_CONF_FILE docker-compose --file proxies/nginx/docker-compose-nginx.yaml down
node ../sla-wizard/src/index.js config nginx --oas specs/simple_api_oas.yaml --sla specs/slas/ --outFile /tmp/$PROXY_CONF_FILE
CFG_PATH=/tmp/$PROXY_CONF_FILE docker-compose --file proxies/nginx/docker-compose-nginx.yaml up #--build

## Query

PROXY_CONF_FILE=proxy-configuration-nginx-query.conf
CFG_PATH=/tmp/$PROXY_CONF_FILE docker-compose --file proxies/nginx/docker-compose-nginx.yaml down
node ../sla-wizard/src/index.js config nginx --oas specs/simple_api_oas.yaml --sla specs/slas/ --outFile /tmp/$PROXY_CONF_FILE --authLocation query
CFG_PATH=/tmp/$PROXY_CONF_FILE docker-compose --file proxies/nginx/docker-compose-nginx.yaml up #--build

## Url

PROXY_CONF_FILE=proxy-configuration-nginx-url.conf
CFG_PATH=/tmp/$PROXY_CONF_FILE docker-compose --file proxies/nginx/docker-compose-nginx.yaml down
node ../sla-wizard/src/index.js config nginx --oas specs/simple_api_oas.yaml --sla specs/slas/ --outFile /tmp/$PROXY_CONF_FILE --authLocation url
CFG_PATH=/tmp/$PROXY_CONF_FILE docker-compose --file proxies/nginx/docker-compose-nginx.yaml up #--build


######### TRAEFIK

## Header

PROXY_CONF_FILE=proxy-configuration-traefik-header.yaml
D_CFG_PATH=/tmp/$PROXY_CONF_FILE CFG_PATH=./traefik.yaml docker-compose --file proxies/traefik/docker-compose-traefik.yaml down
node ../sla-wizard/src/index.js config traefik --oas specs/simple_api_oas.yaml --sla specs/slas/  --outFile /tmp/$PROXY_CONF_FILE
D_CFG_PATH=/tmp/$PROXY_CONF_FILE CFG_PATH=./traefik.yaml docker-compose --file proxies/traefik/docker-compose-traefik.yaml up #--build

## Query

PROXY_CONF_FILE=proxy-configuration-traefik-query.yaml
D_CFG_PATH=/tmp/$PROXY_CONF_FILE CFG_PATH=./traefik.yaml docker-compose --file proxies/traefik/docker-compose-traefik.yaml down
node ../sla-wizard/src/index.js config traefik --oas specs/simple_api_oas.yaml --sla specs/slas/ --outFile /tmp/$PROXY_CONF_FILE --authLocation query
D_CFG_PATH=/tmp/$PROXY_CONF_FILE CFG_PATH=./traefik.yaml docker-compose --file proxies/traefik/docker-compose-traefik.yaml up #--build

## Url

PROXY_CONF_FILE=proxy-configuration-traefik-url.yaml
D_CFG_PATH=/tmp/$PROXY_CONF_FILE CFG_PATH=./traefik.yaml docker-compose --file proxies/traefik/docker-compose-traefik.yaml down
node ../sla-wizard/src/index.js config traefik --oas specs/simple_api_oas.yaml --sla specs/slas/ --outFile /tmp/$PROXY_CONF_FILE --authLocation url
D_CFG_PATH=/tmp/$PROXY_CONF_FILE CFG_PATH=./traefik.yaml docker-compose --file proxies/traefik/docker-compose-traefik.yaml up #--build
