# Homelab

## Hardware
- Linux server
  - i5-4690k
  - 16gb ram
  - no gpu
- Homelab-node-0
    - N150 mini pc
- Homelab-node-1
    - N150 mini pc

## Operating systems
- Linux server: ubuntu 24.05
- Homelab-node-0: NixOS
- Homelab-node-1: NixOS

## Software
- nodes managed via nix flakes deployed via linux server - see deploy.sh inside of /repo/nixos/deploy.sh



# TO DO
- internal network https
- check out multi-region kubernetes setup