ENVOY_IMAGE='envoyproxy\/envoy:v1.26.0'
HAPROXY_IMAGE='haproxytech\/haproxy-alpine:2.7.0'
NGINX_IMAGE='nginx:1.23.2'
TRAEFIK_IMAGE='traefik:2.10.1'

ENVOY_IMAGE_LATEST='envoyproxy\/envoy-dev:latest'
HAPROXY_IMAGE_LATEST='haproxytech\/haproxy-alpine:latest'
NGINX_IMAGE_LATEST='nginx:latest'
TRAEFIK_IMAGE_LATEST='traefik:latest'

if [[ $1 = "latest" ]]; then
    sed -i "s/$ENVOY_IMAGE/$ENVOY_IMAGE_LATEST/" proxies/envoy/docker-compose-envoy.yaml
    sed -i "s/$HAPROXY_IMAGE/$HAPROXY_IMAGE_LATEST/" proxies/haproxy/docker-compose-haproxy.yaml
    sed -i "s/$NGINX_IMAGE/$NGINX_IMAGE_LATEST/" proxies/nginx/docker-compose-nginx.yaml
    sed -i "s/$TRAEFIK_IMAGE/$TRAEFIK_IMAGE_LATEST/" proxies/traefik/docker-compose-traefik.yaml    
fi

if [[ $1 = "pinned" ]]; then
    sed -i "s/$ENVOY_IMAGE_LATEST/$ENVOY_IMAGE/" proxies/envoy/docker-compose-envoy.yaml
    sed -i "s/$HAPROXY_IMAGE_LATEST/$HAPROXY_IMAGE/" proxies/haproxy/docker-compose-haproxy.yaml
    sed -i "s/$NGINX_IMAGE_LATEST/$NGINX_IMAGE/" proxies/nginx/docker-compose-nginx.yaml
    sed -i "s/$TRAEFIK_IMAGE_LATEST/$TRAEFIK_IMAGE/" proxies/traefik/docker-compose-traefik.yaml
fi