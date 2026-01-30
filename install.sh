#!/bin/bash
# Install Code Scanner using Helm

set -e

# Configuration
RELEASE_NAME="${RELEASE_NAME:-rundmc-whisper-nim-diarization-app}"
NAMESPACE="${NAMESPACE:-default}"
VALUES_FILE="${VALUES_FILE:-values.yaml}"

echo "🚀 Installing Code Scanner..."
echo "   Release: ${RELEASE_NAME}"
echo "   Namespace: ${NAMESPACE}"
echo ""

cd "$(dirname "$0")/helm"

# Create namespace if it doesn't exist
kubectl create namespace ${NAMESPACE} --dry-run=client -o yaml | kubectl apply -f -

# Package the chart
helm package .

# Install/Upgrade
helm upgrade --install ${RELEASE_NAME} ./rundmc-whisper-nim-diarization-app-*.tgz \
  --namespace ${NAMESPACE} \
  -f ${VALUES_FILE} \
  "$@"

echo ""
echo "✅ Installation complete!"
echo ""
echo "Check status:"
echo "   kubectl get pods -n ${NAMESPACE} -l app=rundmc-whisper-nim-diarization-app"
echo ""
echo "View logs:"
echo "   kubectl logs -n ${NAMESPACE} -l app=rundmc-whisper-nim-diarization-app -f"
