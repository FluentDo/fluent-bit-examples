# otel-collector

Various examples showing how to send data from Fluent Bit to the OTEL collector using the OTEL standard.

The `otel-config.yaml` file is intended to be used by the OTEL collector to configure itself to receive data:
- 4317 port is used for gRPC protocol
- 4318 port is used for http protocol

The collector will then just print out the data it has received for this example but this can be extended to whatever you need to do.

A full [compose stack](./docker-compose.yaml) is provided to run up both components automatically.

The examples include:
- Simple dummy logs data via `fluent-bit.yaml`
- Metrics format data via `fluent-bit-metrics.yaml`
- gRPC protocol usage instead of http via `fluent-bit-grpc.yaml`
- Specifying different keys to use as the log data for OTEL via `fluent-bit-multikey.yaml`
