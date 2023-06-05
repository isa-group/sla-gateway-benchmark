EXTRA_REQUESTS=3
MINUTES_TO_RUN=3
SECONDS_TO_RUN=30

cd ..

for auth_location in url query header; do

    echo "authLocation: $auth_location" > config/basicTestConfig.yaml
    echo "extraRequests: $EXTRA_REQUESTS" >> config/basicTestConfig.yaml
    echo "minutesToRun: $MINUTES_TO_RUN" >> config/basicTestConfig.yaml
    echo "secondsToRun: $SECONDS_TO_RUN" >> config/basicTestConfig.yaml
    
    make benchmark_1 \
    SLA_WIZARD_PATH=../sla-wizard/ \
    CSV_FILE_BMK1=/tmp/npm_test_full_$auth_location.csv \
    EXPECTED_RESULTS="120 24 360 48 600 1200 240 3600 480 6000" \
    NT_TEST_CONFIG=../sla-gateway-benchmark/config/basicTestConfig.yaml \
    NT_OAS4TEST=../sla-gateway-benchmark/specs/simple_api_oas.yaml \
    NT_SLAS_PATH=../sla-gateway-benchmark/specs/slas/ \
    AUTH_LOCATION=$auth_location

done

cd misc