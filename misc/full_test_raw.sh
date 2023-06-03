# ( this should be run inside sla-gateway-benchmark/ )

######### Envoy

## Header

PROXY_CONF_FILE=proxy-configuration-envoy-header.yaml
node ../sla-wizard/src/index.js config envoy --oas specs/simple_api_oas.yaml --sla specs/slas/ --outFile /tmp/$PROXY_CONF_FILE
CFG_PATH=/tmp/$PROXY_CONF_FILE docker-compose --file proxies/envoy/docker-compose-envoy.yaml up --detach
time TEST_CONFIG=../sla-gateway-benchmark/config/basicTestConfig.yaml OAS4TEST=../sla-gateway-benchmark/specs/simple_api_oas.yaml SLAS_PATH=../sla-gateway-benchmark/specs/slas/ npm --prefix ../sla-wizard/ test > envoy_logs
CFG_PATH=/tmp/$PROXY_CONF_FILE docker-compose --file proxies/envoy/docker-compose-envoy.yaml down

######### HAProxy

## Header

PROXY_CONF_FILE=proxy-configuration-haproxy-header.cfg
node ../sla-wizard/src/index.js config haproxy --oas specs/simple_api_oas.yaml --sla specs/slas/ --outFile /tmp/$PROXY_CONF_FILE
CFG_PATH=/tmp/$PROXY_CONF_FILE docker-compose --file proxies/haproxy/docker-compose-haproxy.yaml up --detach
time TEST_CONFIG=../sla-gateway-benchmark/config/basicTestConfig.yaml OAS4TEST=../sla-gateway-benchmark/specs/simple_api_oas.yaml SLAS_PATH=../sla-gateway-benchmark/specs/slas/ npm --prefix ../sla-wizard/ test > haproxy_logs
CFG_PATH=/tmp/$PROXY_CONF_FILE docker-compose --file proxies/haproxy/docker-compose-haproxy.yaml down

######### NGINX

## Header

PROXY_CONF_FILE=proxy-configuration-nginx-header.conf
node ../sla-wizard/src/index.js config nginx --oas specs/simple_api_oas.yaml --sla specs/slas/ --outFile /tmp/$PROXY_CONF_FILE
CFG_PATH=/tmp/$PROXY_CONF_FILE docker-compose --file proxies/nginx/docker-compose-nginx.yaml up --detach
time TEST_CONFIG=../sla-gateway-benchmark/config/basicTestConfig.yaml OAS4TEST=../sla-gateway-benchmark/specs/simple_api_oas.yaml SLAS_PATH=../sla-gateway-benchmark/specs/slas/ npm --prefix ../sla-wizard/ test > nginx_logs
CFG_PATH=/tmp/$PROXY_CONF_FILE docker-compose --file proxies/nginx/docker-compose-nginx.yaml down

######### TRAEFIK

## Header

PROXY_CONF_FILE=proxy-configuration-traefik-header.yaml
node ../sla-wizard/src/index.js config traefik --oas specs/simple_api_oas.yaml --sla specs/slas/ --outFile /tmp/$PROXY_CONF_FILE
D_CFG_PATH=/tmp/$PROXY_CONF_FILE CFG_PATH=./traefik.yaml docker-compose --file proxies/traefik/docker-compose-traefik.yaml up --detach
time TEST_CONFIG=../sla-gateway-benchmark/config/basicTestConfig.yaml OAS4TEST=../sla-gateway-benchmark/specs/simple_api_oas.yaml SLAS_PATH=../sla-gateway-benchmark/specs/slas/ npm --prefix ../sla-wizard/ test > traefik_logs
D_CFG_PATH=/tmp/$PROXY_CONF_FILE CFG_PATH=./traefik.yaml docker-compose --file proxies/traefik/docker-compose-traefik.yaml down

##################

## Show results
for file in $(ls *_logs) ; do echo $file ; cat $file | grep "to equal" ; done
