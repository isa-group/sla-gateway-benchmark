CSV_FILE_BMK1 ?= /tmp/npm_test_full.csv

CSV_FILE_BMK2 ?= /tmp/npm_test_loops.csv

AUTH_LOCATION ?= header

BMK2_ITERATIONS ?= 3

benchmark_1:

	@ if [ "${SLA_WIZARD_PATH}" = "" ]; then \
		echo "SLA_WIZARD_PATH not set"; \
		exit 1; \
	fi

	@ echo "Proxy,[basic] GET /pets - 1/s,[basic] POST /pets - 2/m,[basic] GET /pets/id - 3/s,[basic] PUT /pets/id - 4/m,[basic] DELETE /pets/id - 5/s,\
	[pro] GET /pets - 10/s,[pro] POST /pets - 20/m,[pro] GET /pets/id - 30/s,[pro] PUT /pets/id - 40/m,[pro] DELETE /pets/id - 50/s" > ${CSV_FILE_BMK1}

	@ for proxy in envoy haproxy nginx traefik; do \
		node ${SLA_WIZARD_PATH}/src/index.js config --authLocation ${AUTH_LOCATION} $$proxy \
			--oas ${SLA_WIZARD_PATH}/spec_samples/simple_api_oas.yaml \
			--sla ${SLA_WIZARD_PATH}/spec_samples/slas/ \
			--outFile /tmp/proxy-configuration-file ; \
		echo created config file, now docker-compose up ; \
		if [ "$$proxy" = "traefik" ]; then \
			D_CFG_PATH=/tmp/proxy-configuration-file CFG_PATH=./traefik.yaml docker-compose \
				--file proxies/$$proxy/docker-compose-$$proxy.yaml up \
				--detach ; \
		else \
			CFG_PATH=/tmp/proxy-configuration-file docker-compose \
				--file proxies/$$proxy/docker-compose-$$proxy.yaml up \
				--detach ; \
		fi ; \
		echo after docker-compose up, going to sleep now ; \
		sleep 4 # Wait until containers are ready and launch test ; \
		npm --prefix ${SLA_WIZARD_PATH} test > /tmp/npm_test_logs ; \
		echo after npm test ; \
		CFG_PATH=/tmp/proxy-configuration-file docker-compose --file proxies/$$proxy/docker-compose-$$proxy.yaml down ; \
		echo -n $$proxy, >> ${CSV_FILE_BMK1} ; \
		#for expected in 9 12 27 24 45 90 120 270 240 450; do \
		for expected in 90 18 270 36 450 900 180 2700 360 4500; do \
			cat /tmp/npm_test_logs | grep "to equal $$expected$$" | sed 's/to equal/instead of/g' | sed 's/AssertionError: expected/Got/g' > /tmp/auxFileBMK1 ; \
			result=$$(cat /tmp/auxFileBMK1); \
			echo -n $$result, >> ${CSV_FILE_BMK1} ; \
		done ; \
		echo >> ${CSV_FILE_BMK1} ; \
	done ; \


benchmark_2:

	@ if [ "${SLA_WIZARD_PATH}" = "" ]; then \
		echo "SLA_WIZARD_PATH not set"; \
		exit 1; \
	fi

	@ cp ${SLA_WIZARD_PATH}/tests/basicTestConfig.yaml ${SLA_WIZARD_PATH}/tests/basicTestConfig_original.yaml ; \
	echo "authLocation: header" > ${SLA_WIZARD_PATH}/tests/basicTestConfig.yaml ; \
	echo "extraRequests: 2" >> ${SLA_WIZARD_PATH}/tests/basicTestConfig.yaml ; \
	#echo "minutesToRun: 0" >> ${SLA_WIZARD_PATH}/tests/basicTestConfig.yaml ; \
	echo "secondsToRun: 3" >> ${SLA_WIZARD_PATH}/tests/basicTestConfig.yaml ; \
	
	@ echo "Proxy,Sleep 0s,Sleep 0.25s,Sleep 0.5s,Sleep 1s" > ${CSV_FILE_BMK2} ; \

	@ for proxy in envoy haproxy nginx traefik; do \
		node ${SLA_WIZARD_PATH}/src/index.js config --authLocation ${AUTH_LOCATION} $$proxy \
			--oas ${SLA_WIZARD_PATH}/spec_samples/simple_api_oas.yaml \
			--sla ${SLA_WIZARD_PATH}/spec_samples/slas/ \
			--outFile /tmp/proxy-configuration-file ; \
		echo created config file, now docker-compose up ; \
		if [ "$$proxy" = "traefik" ]; then \
			D_CFG_PATH=/tmp/proxy-configuration-file CFG_PATH=./traefik.yaml docker-compose \
				--file proxies/$$proxy/docker-compose-$$proxy.yaml up \
				--detach ; \
		else \
			CFG_PATH=/tmp/proxy-configuration-file docker-compose \
				--file proxies/$$proxy/docker-compose-$$proxy.yaml up \
				--detach ; \
		fi ; \
		echo after docker-compose up, going to sleep now ; \
		sleep 4 # Wait until containers are ready and launch test ; \
		for sleep_time in 0 0.25 0.5 1; do \
			for iteration in $$( seq 1 ${BMK2_ITERATIONS} ); do \
				npm --prefix ${SLA_WIZARD_PATH} test ; \
				sleep $$sleep_time; \
			done | grep "to equal 450\|Received 200s: 450" | sed 's/.*AssertionError: expected //g' | sed 's/ to equal 450//g' | sed 's/Received 200s: //g' > /tmp/test_sleep$$sleep_time-$$proxy ; \
		done ; \
		CFG_PATH=/tmp/proxy-configuration-file docker-compose --file proxies/$$proxy/docker-compose-$$proxy.yaml down ; \
		for iteration in $$( seq 1 ${BMK2_ITERATIONS} ); do \
			echo -n $$proxy, >> ${CSV_FILE_BMK2} ; \
			for sleep_time in 0 0.25 0.5 1; do \
				echo $$iteration ; \
				echo -n $$(head -$$iteration /tmp/test_sleep$$sleep_time-$$proxy | tail +$$iteration), >> ${CSV_FILE_BMK2} ; \
			done ; \
			echo >> ${CSV_FILE_BMK2} ; \
		done ; \
	done ; \