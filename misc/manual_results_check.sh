for proxy in envoy haproxy nginx traefik; do

    echo "##### $proxy"

    echo "BASIC PLAN"

    echo "HTTP 200"
    cat /tmp/${proxy}_proxy_1_logs | grep basicplan-sla1-apikey1 | grep 200 | wc
    cat /tmp/${proxy}_proxy_1_logs | grep basicplan-sla1-apikey2 | grep 200 | wc
    cat /tmp/${proxy}_proxy_1_logs | grep basicplan-sla2-apikey1 | grep 200 | wc
    cat /tmp/${proxy}_proxy_1_logs | grep basicplan-sla2-apikey2 | grep 200 | wc
    
    echo "HTTP 429"
    cat /tmp/${proxy}_proxy_1_logs | grep basicplan-sla1-apikey1 | grep 429 | wc
    cat /tmp/${proxy}_proxy_1_logs | grep basicplan-sla1-apikey2 | grep 429 | wc
    cat /tmp/${proxy}_proxy_1_logs | grep basicplan-sla2-apikey1 | grep 429 | wc
    cat /tmp/${proxy}_proxy_1_logs | grep basicplan-sla2-apikey2 | grep 429 | wc

    echo --------------------

    echo "PRO PLAN"

    echo "HTTP 200"
    cat /tmp/${proxy}_proxy_1_logs | grep proplan-sla3-apikey1 | grep 200 | wc
    cat /tmp/${proxy}_proxy_1_logs | grep proplan-sla3-apikey2 | grep 200 | wc
    cat /tmp/${proxy}_proxy_1_logs | grep proplan-sla4-apikey1 | grep 200 | wc
    cat /tmp/${proxy}_proxy_1_logs | grep proplan-sla4-apikey2 | grep 200 | wc
    
    echo "HTTP 429"
    cat /tmp/${proxy}_proxy_1_logs | grep proplan-sla3-apikey1 | grep 429 | wc
    cat /tmp/${proxy}_proxy_1_logs | grep proplan-sla3-apikey2 | grep 429 | wc
    cat /tmp/${proxy}_proxy_1_logs | grep proplan-sla4-apikey1 | grep 429 | wc
    cat /tmp/${proxy}_proxy_1_logs | grep proplan-sla4-apikey2 | grep 429 | wc

    echo ::::::::::::::::::::::::::::::::::::::::::

done