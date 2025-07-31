# Homelab

## Overview
This is a homelab for experimenting with linux and kubernetes. The two node machines are running [NixOS](https://nixos.org/) which are managed via [Nix Flakes](https://nixos.wiki/wiki/Flakes) in the nixos [directory](nixos/).

[K3S](https://k3s.io) is installed on the linux-server as the control plane. \
[agenix](https://github.com/ryantm/agenix) is used for encrypting all secrets with the ssh keys. \
[Kubernetes](https://kubernetes.io/) manifests exist in both raw kubernetes templates and helm charts - to increase familiarity with both \



### Hardware
- Linux server
  - i5-4690k
  - 16gb ram
  - no gpu
- Homelab-node-0
    - N150 mini pc
- Homelab-node-1
    - N150 mini pc

### Operating systems
- Linux server: ubuntu 24.05
- Homelab-node-0: NixOS
- Homelab-node-1: NixOS

### Software
#### Services
- Kubernetes
- Grafana
- Spoolman



# TO DO
- internal network https
- check out multi-region kubernetes control plane setup
- install kustomize and helm on nodes