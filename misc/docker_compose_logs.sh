docker logs -f envoy_proxy_1 > /tmp/envoy_proxy_1_logs

docker logs -f haproxy_proxy_1 > /tmp/haproxy_proxy_1_logs

docker logs -f nginx_proxy_1 > /tmp/nginx_proxy_1_logs

docker logs -f traefik_proxy_1 > /tmp/traefik_proxy_1_logs
