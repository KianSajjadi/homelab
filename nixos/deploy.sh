#!/bin/bash
set -e

NODES=(
  "homelab-node-0 root@192.168.0.64"
  "homelab-node-1 root@192.168.0.3"
)

for NODE in "${NODES[@]}"; do
  set -- $NODE
  NAME=$1
  HOST=$2
  echo "Deploying to $NAME ($HOST)..."
  nix run github:NixOS/nixpkgs/nixos-24.05#nixos-rebuild -- switch \
    --flake .#$NAME \
    --target-host $HOST
done