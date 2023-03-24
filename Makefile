# Docker registry
REGISTRY ?= index.docker.io
#Image namespace
NAMESPACE ?= pafmon
# image name
APPNAME ?= do2223-contacts-api
#image default tag
IMAGETAG ?= latest

IMAGENAME = ${REGISTRY}/${NAMESPACE}/${APPNAME}:${IMAGETAG}

PROXY ?= 
AUTH_LOCATION ?= 




benchmark_1:
	#docker build -t ${IMAGENAME} ./generated-server
	#This would produce a CSV with the content of the 'npm test' results table
	for proxy in envoy haproxy nginx traefik; do
		PROXY_CONF_FILE=proxy-configuration-envoy-header.yaml
		node src/index.js config ${proxy} --oas tests/specs/simple_api_oas.yaml --sla tests/specs/slas/ --outFile tests/$PROXY_CONF_FILE
		sudo CFG_PATH=/tmp/$PROXY_CONF_FILE docker-compose --file tests/envoy/docker-compose-envoy.yaml up --detach
		# Wait until containers are ready and launch test
		npm test &> /tmp/${PROXY}
		sudo CFG_PATH=/tmp/$PROXY_CONF_FILE docker-compose --file tests/envoy/docker-compose-envoy.yaml down
		cat /tmp/${PROXY} | grep "to equal" | sed 's/      AssertionError: expected / Got /g' | sed 's/to equal/instead of/g'
	done


benchmark_2:
	#docker push ${IMAGENAME}
	echo "This would produce CSVs with the content needed to produce the grapsh"


clean_image:
	docker rmi ${IMAGENAME}

compose_deploy:
	docker-compose -f ./generated-server/docker-compose.yaml up -d

compose_clean:
	docker-compose -f ./generated-server/docker-compose.yaml down

k8s_deploy:
	kubectl apply -f k8s

k8s_clean:
	kubectl delete -f k8s

k8s_config_binding:
	kubectl create clusterrolebinding permissive-binding \
  --clusterrole=cluster-admin \
  --user=admin \
  --user=kubelet \
  --group=system:serviceaccounts