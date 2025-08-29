#!/bin/bash
set -e

FILENAME=$1

# This uses the public age key for kian-wsl to encrypt files and uses the private key managed via a kubernetes secret created via CLI to decrypt later
sops --encrypt --in-place $1