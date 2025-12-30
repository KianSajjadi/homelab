# Homelab

## Overview
This is a homelab for experimenting with linux and kubernetes. The two node machines are running [NixOS](https://nixos.org/) which are managed via [Nix Flakes](https://nixos.wiki/wiki/Flakes) in the nixos [directory](nixos/).

[K3S](https://k3s.io) is installed on mainboy as the control plane. \
[FluxCD](https://fluxcd.io/) is used for GitOps continuous delivery. \
[agenix](https://github.com/ryantm/agenix) and [sops](https://github.com/mozilla/sops) are used for encrypting secrets with age keys. \
[Kubernetes](https://kubernetes.io/) manifests are managed via Kustomize and Helm charts.

### Hardware
- Mainboy
  - i5-4690k
  - 16gb ram
  - no gpu
- Homelab-node-0
    - N150 mini pc
- Homelab-node-1
    - N150 mini pc

### Operating systems
- mainboy (control plane): Ubuntu 24.04
- Homelab-node-0: NixOS
- Homelab-node-1: NixOS

### Software
#### Services
- **Infrastructure**: K3s, FluxCD, Traefik, cert-manager
- **Monitoring**: Prometheus, Grafana, Node Exporter
- **Applications**: Homepage, Spoolman, Paintman
- **DNS**: AdGuard Home



# Networking
## Ports
  - Traefik 80/443
  - node exporter 9100
  - grafana 3001
  - homepage 3000
  - prometheus 9080
  - paintman 3002
  - weave 9001

## DNS
Split horizon DNS so all .lan forwards to adguard DNS resolver


# TO DO
- ~~internal network https~~
- ~~Split horizon setup for coreDNS~~
- check out multi-region kubernetes control plane setup
- install ~~kustomize~~ and helm on nodes
- github actions self hosted runner
- consider gitea
- ~~add homepage~~
- ~~add traefik-config for 80->8081 443 -> 8444 and manage all routes via nix~~
- ~~add prometheus~~
- ~~add SOPS-nix~~ I ended up using standard SOPS for kubernetes secrets instead of the sops-nix, will look into it further
- ~~make spoolman use postgres and change spoolman deployment to stateful set~~
- ~~use k3s inbuilt volume management~~
- add CI/CD pipeline for applications
- ~~setup weave UI for fluxcd~~
- cron job to backup postgres DB for spoolman
- ~~add node exporter~~
- ~~Consolidate file structure to follow "verb" instead of "noun"~~ - done for monitoring, will continue this convention in future
- Update ingress to gateway at some point
- Add hashicorp vault agent sidecar for dynamic DB credentials for spoolman/postgresdb
- ~~Add paintman kubernetes config~~
- Add local docker image registry