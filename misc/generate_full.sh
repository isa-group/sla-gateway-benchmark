# ipelu@ipllenovo:~/Desktop/uni/tfm/repos/sla-gateway-benchmark (main)$ bash misc/generate_full.sh 

DEST=/home/ipelu/Desktop/uni/tfm/configs_generados_para_memoria_FULL/

for proxy in envoy haproxy nginx traefik; do
    for apikey_location in header query url; do

        if [[ $proxy == "envoy" || $proxy == "traefik" ]]; then
            extension=yaml
        elif [[ $proxy == "haproxy" ]]; then
            extension=cfg
        else
            extension=conf
        fi

        PROXY_CONF_FILE=proxy-configuration-$proxy-$apikey_location.$extension
        node ../sla-wizard/src/index.js config $proxy --oas specs/simple_api_oas.yaml --sla specs/slas/ --outFile $DEST/$PROXY_CONF_FILE --authLocation $apikey_location
    done
done