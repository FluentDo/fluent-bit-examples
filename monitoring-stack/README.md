# monitoring-stack

Simple example running up a two-tier Fluent Bit of forwarder daemonsets to aggregator deployments along with a kube-prometheus-stack including Prometheus and Grafana to monitor it.

A [`run-fluent-bit.sh`](run-fluent-bit.sh) launch script is provided to deploy this all to an existing K8S cluster.

A sample dashboard is provided to monitor it all in [`dashboard.json`](./dashboard.json). This can be imported into the Grafana instance once running.

## KIND set up

A sample 4 node KIND [configuration](./kind-config.yaml) is provided to simulate multiple nodes.

To use, run `kind create cluster --config=./kind-config.yaml`.
After the cluster is running, you can then deploy the Fluent Bit helm chart to it.
