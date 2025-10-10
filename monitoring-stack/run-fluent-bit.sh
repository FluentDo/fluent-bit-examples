#!/bin/bash
set -eu

# Get current script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Check if Helm is installed
if ! command -v helm &> /dev/null; then
    echo "Helm is not installed. Please install Helm first."
    exit 1
fi
# Check if the Kubernetes cluster is running
if ! kubectl cluster-info &> /dev/null; then
    echo "Kubernetes cluster is not running. Please start your Kubernetes cluster first."
    exit 1
fi

# Add the Helm repository for Grafana
helm repo add fluent https://fluent.github.io/helm-charts --force-update
helm repo update --fail-on-repo-update-fail

NAMESPACE=${NAMESPACE:-monitoring}
echo "Using namespace: ${NAMESPACE}"

# Run up the daemonset/forwarder first
helm upgrade --install fluent-bit-forwarder fluent/fluent-bit \
    --namespace "${NAMESPACE}" \
    --create-namespace \
    --values "$SCRIPT_DIR/values-ds.yaml" \
    --wait

# Run up the aggregator next
helm upgrade --install fluent-bit-aggregator fluent/fluent-bit \
    --namespace "${NAMESPACE}" \
    --create-namespace \
    --values "$SCRIPT_DIR/values-aggregator.yaml" \
    --wait

# Now run up the monitoring stack
# We use a fixed name as part of service monitor definition, similarly keep in same namespace for easy use
helm upgrade --install -n "${NAMESPACE}" --create-namespace \
	--wait \
	kube-prom-stack \
	oci://ghcr.io/prometheus-community/charts/kube-prometheus-stack

echo "Grafana admin password: "
kubectl --namespace monitoring get secrets kube-prom-stack-grafana -o jsonpath="{.data.admin-password}" | base64 -d ; echo

echo "Port forwarding to http://localhost:3000"
kubectl --namespace monitoring port-forward \
	"$(kubectl --namespace monitoring get pod -l "app.kubernetes.io/name=grafana,app.kubernetes.io/instance=kube-prom-stack" -oname)" \
	3000 &
