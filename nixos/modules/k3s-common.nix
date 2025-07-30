{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    git
    vim
    curl
    htop
    age
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Australia/Sydney";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_AU.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_AU.UTF-8";
    LC_IDENTIFICATION = "en_AU.UTF-8";
    LC_MEASUREMENT = "en_AU.UTF-8";
    LC_MONETARY = "en_AU.UTF-8";
    LC_NAME = "en_AU.UTF-8";
    LC_NUMERIC = "en_AU.UTF-8";
    LC_PAPER = "en_AU.UTF-8";
    LC_TELEPHONE = "en_AU.UTF-8";
    LC_TIME = "en_AU.UTF-8";
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
    ];
  };

  nix.settings.auto-optimise-store = true;

# ################################### PORTS ################################## #
  # needed for k3s setup
  networking.firewall.allowedTCPPorts = [ 22 6443 10250 ];
  # networking.firewall.allowedUDPPorts = [ ... ];

  # Install firefox.
  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    ports = [ 22 ];
    settings = {
      PasswordAuthentication = true;
      AllowedUsers = null;
      UseDns = true;
      X11Forwarding = false;
      PermitRootLogin = "prohibit-password";
    };
  };

  systemd.targets.sleep.enable = false;
  systemd.targets.suspend.enable = false;
  systemd.targets.hibernate.enable = false;
  systemd.targets.hybrid-sleep.enable = false;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  /* ########################################################################## */
  /*                                   SECRETS                                  */
  /* ########################################################################## */
  age.identityPaths = [ "/home/kian/.ssh/id_ed25519" ];
  /* ############################### K3S TOKENS ############################### */
  age.secrets.k3s-token = {
    file = ../secrets/k3s-token.age;
    path = "/etc/k3s-token";
    owner = "root";
    mode = "0400";
  };

  age.secrets.k3s-url = {
    file = ../secrets/k3s-url.age;
    path = "/etc/k3s-url";
    owner = "root";
    mode = "0400";
  };

  /* ########################################################################## */
  /*                                  ENV VARS                                  */
  /* ########################################################################## */

  /* ################################### K3S ################################## */
  environment.variables = {
    K3S_TOKEN = "@/etc/k3s-token";
    K3S_URL = "@/etc/k3s-url";
  };


  /* ########################################################################## */
  /*                                  SERVICES                                  */
  /* ########################################################################## */

  /* ################################### K3S ################################## */
  services.k3s = {
    enable = true;
    role = "agent";
    tokenFile = "/etc/k3s-token";  
    serverAddr = "https://192.168.0.251:6443";
  };
  # systemd.services.k3s-agent = {
  #   environment = {
  #     K3S_TOKEN = "@/etc/k3s-token";
  #     K3S_URL = "@/etc/k3s-url";
  #   };
  # };
}