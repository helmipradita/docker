#!/bin/bash

set -euo pipefail

NETWORK_NAME=${1:-local-dev-network}

if docker network inspect "$NETWORK_NAME" >/dev/null 2>&1; then
  echo "Network '$NETWORK_NAME' already exists."
else
  echo "Creating Docker network '$NETWORK_NAME'..."
  docker network create "$NETWORK_NAME"
  echo "Network '$NETWORK_NAME' created."
fi
