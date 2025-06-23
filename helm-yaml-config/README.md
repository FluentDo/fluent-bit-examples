# helm-yaml-config

A simple example of deploying YAML configuration syntax with the existing [OSS helm chart](https://github.com/fluent/helm-charts/tree/main/charts/fluent-bit).

A [`values.yaml`](values.yaml) is provided that can be passed to the OSS helm chart to set up the YAML configuration.

A [`run-fluent-bit.sh`](run-fluent-bit.sh) launch script is provided to deploy this all to an existing K8S cluster.

The main things you need to do are:
- Ensure a file ending in .yaml is created in the config map.
- Ensure the default launch parameters are set to pass this config file name to the container.
