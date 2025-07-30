{ config, pkgs, ... }:

{
  imports = [
    ../hardware/homelab-node-1.nix
  ];

  networking.hostName = "homelab-node-1";

  system.stateVersion = "25.05";
  boot.loader.grub.devices = [ "/dev/sda" ];
}