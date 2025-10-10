# kube-audit-logs

A simple example intended to be used with [KIND](./https://kind.sigs.k8s.io/) to create a K8S cluster with audit logging enabled and then deploy an example Fluent Bit daemonset to read it.

A [`values.yaml`](values.yaml) is provided that can be passed to the [OSS helm chart](https://github.com/fluent/helm-charts/tree/main/charts/fluent-bit) to set up the YAML configuration.

A [`run-fluent-bit.sh`](run-fluent-bit.sh) launch script is provided to deploy this all to an existing K8S cluster.

## KIND set up

To deploy with KIND the two configuration files are provided:

- [`audit-policy.yaml`](./audit-policy.yaml) to provide an audit logging policy.
- [`kind-config.yaml`](./kind-config.yaml) to provide the actual KIND configuration to mount and use the policy.

To use, run `kind create cluster --config=./kind-config.yaml`.
After the cluster is running, you can then deploy the Fluent Bit helm chart to it.
