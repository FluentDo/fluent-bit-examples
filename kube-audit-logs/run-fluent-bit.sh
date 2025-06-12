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

NAMESPACE=${NAMESPACE:-fluent-bit}
echo "Using namespace: ${NAMESPACE}"

helm upgrade --install fluent-bit fluent/fluent-bit \
    --namespace "${NAMESPACE}" \
    --create-namespace \
    --values "${VALUES_FILE:-"$SCRIPT_DIR/values.yaml"}" \
    --wait

