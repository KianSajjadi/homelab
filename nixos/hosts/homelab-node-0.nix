{ config, pkgs, ... }:

{
  imports = [
    ../hardware/homelab-node-0.nix
  ];

  networking.hostName = "homelab-node-0";

  system.stateVersion = "25.05";
  boot.loader.grub.devices = [ "/dev/sda" ];
}