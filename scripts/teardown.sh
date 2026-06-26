#!/bin/bash

set -euo pipefail

CLUSTER_NAME="ixtli"

# delete cluster running
kind delete cluster --name "$CLUSTER_NAME"

echo "The cluster '${CLUSTER_NAME}' is now deleted!"