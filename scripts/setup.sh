#!/bin/bash
set -euo pipefail # makes bash strict so mistakes stop the script instead of slipping through
CLUSTER_NAME="ixtli"
CONFIG="cluster/kind-config.yaml"

# checks if cluster exists
if kind get clusters | grep -q "^${CLUSTER_NAME}$"; then # -q: quietly yes or no
    echo "Cluster '${CLUSTER_NAME}' already exists, you're good!"
    exit 0
fi

# creates cluster if none exists
echo "Creating '${CLUSTER_NAME}'..."
kind create cluster --name "$CLUSTER_NAME" --config "$CONFIG"
echo "Cluster '${CLUSTER_NAME}' created!"