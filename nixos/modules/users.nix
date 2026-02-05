with { config, pks, ... }:

{ 
  security.sudo = {
    enable = true;
    wheelNeedsPassword = false;
  };

  users.users.kian = {
    isNormalUser = true;
    description = "kian";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
    #  thunderbird
    ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFRpUd/ZkFdn1A5P2m1uoTvOmNz8LZOzth6rNlIV55lm kian@kian-pc"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINJhJu2Ex2nRgRR7Ns4RJ+/Qt3q6SXHNHAxeoApEmv5K kian@mainboy"
    ];
  };

  users.users.sia = {
    isNormalUser = true;
    description = "Sia";
    extraGroups = [ "wheel" "networkmanager" ];
    packages = with pkgs; [
      #etc
    ];

    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBnb1wEsZL/wmWOisNeT3oEoiP0LnmEd/NVQ3RwJ4rER sia@strongbox"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGYWPtuzgxIuDlKRe4XDQdYPu9N8vAijzCe4GyW8JXxl sia@eyestrainer"
    ];
  };

  
}