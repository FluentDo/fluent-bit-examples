# Grafana stack

Simple helper script and support files to use the [`loki-stack` helm chart](https://github.com/grafana/helm-charts/tree/main/charts/loki-stack) to deploy:

- Loki
- Prometheus
- Grafana

And supporting configuration/dashboards/etc.

Once deployed via [`run-grafana-stack.sh`](./run-grafana-stack.sh) just browse to <http://localhost:3000> to access with default credentials `admin:admin`.

Custom dashboards are added via the [`values.yaml`](./values.yaml) file along with any other customisation to make to the stack.
