# fluent-bit-examples

Useful examples of using Fluent Bit split into sub-directories by use case:

- [`helm-yaml-config`](./helm-yaml-config/): how to use the new YAML configuration syntax with the existing OSS helm chart.
- [`kube-audit-logs`](./kube-audit-logs/): how to set up KIND to export audit logs and then consume them with the OSS helm chart.
- [`otel-collector`](./otel-collector/): how to configure Fluent Bit to send (various test) OTEL data to the OTEL collector.

In each case the examples are simple but a good starting point to understand how to extend into a specific need.

More detailed information and support is available via our consultancy at: <https://fluent.do>
