# sla-gateway-benchmark

With this tool we provide two benchmarks for API proxies. 

It makes use of `sla-wizard`, so for being able to use it please pull first that tool [from its public repo](https://github.com/isa-group/sla-wizard). 

### Benchmark 1

This benchmark focuses on testing all endpoints in the SLA on several proxies. In a nutshell, it performs the following:

For each proxy of the four currently supported, configure the run of the benchmark, generate the proxy configuration file with sla-wizard, launch the testing bed based on Docker-Compose 6, launches the testing and eventually parses the obtained logs to generate a CSV file containing the results.

### Benchmark 2

Unlike the first benchmark, this one focuses on a specific endpoint and performs testing for multiple iterations, with varying delays between iterations. 

This is, if the endpoint has a rate limiting of "per second" the benchmark would send several requests to it over multiple seconds. 

More precisely, what it does is as follows:

For each proxy of the four currently supported, configure the run of the benchmark and launch the testing bed based on Docker-Compose. Following, for each of the 4 sleep times, performs 20 iterations with a delay between iterations of the specific sleep time. Eventually, all the produced logs are parsed to generate a CSV file containing the results. The Python script `misc/plots.py` can be used to plot the results obtained with this benchmark.

## Configuration

The table below indicates the different congifuration variables that can be used with the benchmarks: 

| Variable         | Benchmark | Purpose | Default value |
| ---------------- | --------- | ------- | ------- |
| SLA_WIZARD_PATH  | both      | Path to the location of the `sla-wizard`. | - |
| PROXIES          | both      | Proxies to run the benchmark(s) on. | "envoy haproxy nginx traefik" |
| NT_OAS4TEST      | both      | Path to the API's OAS document. | ../sla-gateway-benchmark/specs/simple_api_oas.yaml |
| NT_SLAS_PATH     | both      | Path to the API's SLAs. | ../sla-gateway-benchmark/specs/slas/ |
| AUTH_LOCATION    | both      | Location where the API key is sent to the proxy. Can be header, query or url. Note for benchmark 1 this must match the value of `authLocation` used in the test config file (NT_TEST_CONFIG)| header |
| EXPECTED_RESULTS | 1         | A list of integers indicating the expected accepted requests for each endpoint. | "120 24 360 48 600 1200 240 3600 480 6000" |
| NT_TEST_CONFIG   | 1         | Path to the test run configuration file. | ../sla-gateway-benchmark/config/basicTestConfig.yaml |
| CSV_FILE_BMK1    | 1         | File where to write the CSV obtained by benchmark 1. | /tmp/npm_test_full.csv |
| CSV_FILE_BMK2    | 2         | File where to write the CSV obtained by benchmark 2. | /tmp/npm_test_loops.csv |
| BMK2_ITERATIONS  | 2         | Iterations to perform of `npm test` for each proxy in benchmark 2. | 10 |
| NPM_TEST_DELAYS  | 2         | Different values of delay that should be used in between iterations of `npm test` in benchmark 2. | "0 0.25 0.5 1" |

Following, we show a few examples on how to run both of these benchmarks.

## Examples 

### Benchmark 1

```bash
make benchmark_1 \
  SLA_WIZARD_PATH=../sla-wizard/ \
  CSV_FILE_BMK1=/tmp/npm_test_full.csv \
  PROXIES="envoy" \
  EXPECTED_RESULTS="120 24 360 48 600 1200 240 3600 480 6000" \
  NT_TEST_CONFIG=../sla-gateway-benchmark/config/basicTestConfig.yaml \
  NT_OAS4TEST=../sla-gateway-benchmark/specs/simple_api_oas.yaml \
  NT_SLAS_PATH=../sla-gateway-benchmark/specs/slas/ \
  AUTH_LOCATION=query

make benchmark_1 \
  SLA_WIZARD_PATH=../sla-wizard/ \
  CSV_FILE_BMK1=/tmp/npm_test_full.csv \
  PROXIES="haproxy traefik" \
  EXPECTED_RESULTS="270 54 810 108 1350 2700 540 8100 1080 13500" \
  NT_TEST_CONFIG=../sla-gateway-benchmark/config/basicTestConfig.yaml \
  NT_OAS4TEST=../sla-gateway-benchmark/specs/simple_api_oas.yaml \
  NT_SLAS_PATH=../sla-gateway-benchmark/specs/slas/ \
  AUTH_LOCATION=url

make benchmark_1 \
  SLA_WIZARD_PATH=../sla-wizard/ \
  CSV_FILE_BMK1=/tmp/npm_test_full.csv \
  PROXIES="envoy traefik"
```

### Benchmark 2

```bash
make benchmark_2 \
  SLA_WIZARD_PATH=../sla-wizard/ \
  CSV_FILE_BMK1=/tmp/npm_test_loops.csv \
  PROXIES="envoy" \
  NT_TEST_CONFIG=../sla-gateway-benchmark/config/basicTestConfig.yaml \
  NT_OAS4TEST=../sla-gateway-benchmark/specs/simple_api_oas.yaml \
  NT_SLAS_PATH=../sla-gateway-benchmark/specs/slas/ \
  AUTH_LOCATION=header

make benchmark_2 \
  SLA_WIZARD_PATH=../sla-wizard/ \
  CSV_FILE_BMK2=/tmp/npm_test_loops.csv \
  BMK2_ITERATIONS=4 \
  PROXIES="envoy nginx"
```
