{ config, pkgs, ... }:

{
  imports = [
    ../hardware/homelab-node-1.nix
  ];

  networking.hostName = "homelab-node-1";
  networking.hostId = "9dc2460a";

  system.stateVersion = "25.05";
  boot.loader.grub.devices = [ "/dev/sda" ];
  nix.settings.trusted-users = [ "root" "kian" ];
}