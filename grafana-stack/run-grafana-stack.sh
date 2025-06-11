#!/bin/bash
set -eu

# Check if Helm is installed
if ! command -v helm &> /dev/null; then
    echo "Helm is not installed. Please install Helm first."
    exit 1
fi
# Check if kubectl is installed
if ! command -v kubectl &> /dev/null; then
    echo "kubectl is not installed. Please install kubectl first."
    exit 1
fi
# Check if the Kubernetes cluster is running
if ! kubectl cluster-info &> /dev/null; then
    echo "Kubernetes cluster is not running. Please start your Kubernetes cluster first."
    exit 1
fi

# Add the Helm repository for Grafana
helm repo add grafana https://grafana.github.io/helm-charts --force-update
helm repo update --fail-on-repo-update-fail

NAMESPACE=${NAMESPACE:-grafana}
# Create the namespace if it doesn't exist
kubectl create namespace "${NAMESPACE}" --dry-run=client -o yaml | kubectl apply -f -
# Check if the namespace was created successfully
if ! kubectl get namespace "${NAMESPACE}" &> /dev/null; then
    echo "Failed to create namespace ${NAMESPACE}. Please check your Kubernetes configuration."
    exit 1
fi

# Deploy the Loki stack with Grafana and Prometheus - assuming no RBAC or other issues 
if [ -z "${GRAFANA_CHART_VERSION:-}" ]; then
    echo "GRAFANA_CHART_VERSION is not set. Using default version 2.10.2."
    GRAFANA_CHART_VERSION="2.10.2"
fi
if [ -z "${GRAFANA_ADMIN_PASSWORD:-}" ]; then
    echo "GRAFANA_ADMIN_PASSWORD is not set. Using default password 'admin'."
    GRAFANA_ADMIN_PASSWORD="admin"
fi
helm upgrade --install loki-stack grafana/loki-stack \
    --namespace "${NAMESPACE}" \
    --create-namespace \
    --version "${GRAFANA_CHART_VERSION}" \
    --set grafana.enabled=true,prometheus.enabled=true,promtail.enabled=false \
    --set grafana.adminPassword="${GRAFANA_ADMIN_PASSWORD}" \
    --wait

# Forward to the Grafana service
echo "Grafana is running at http://localhost:3000"
echo "Username: admin"
echo "Password: ${GRAFANA_ADMIN_PASSWORD}"

kubectl port-forward -n "${NAMESPACE}" svc/loki-stack-grafana 3000:80 &
# Wait for the port-forward to be established
wait $!

# Note: You can access Grafana at http://localhost:3000
# To stop the port-forward, you can use Ctrl+C
# To access the Grafana UI, open your browser and go to http://localhost:3000
# To access the Loki logs, you can use the Grafana UI
# or use the Loki API directly at http://localhost:3100
# To access the Prometheus UI, you can use the following command:
# kubectl port-forward -n "${NAMESPACE}" svc/loki-prometheus 9090:9090

