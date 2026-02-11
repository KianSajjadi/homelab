{ config, pkgs, ... }:

{
  /* ################################ PACKAGES ################################ */
  environment.systemPackages = with pkgs; [
    git
    vim
    curl
    htop
    age
    dig
    sops
    zfs
    lsof
    sysstat
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "zfs" ];

  networking.networkmanager.enable = true;

  time.timeZone = "Australia/Sydney";

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

  security.sudo = {
    enable = true;
    wheelNeedsPassword = false;
  };

  users.users.kian = {
    isNormalUser = true;
    description = "kian";
    extraGroups = [ "networkmanager" "wheel" "smb"];
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
    extraGroups = [ "wheel" "networkmanager" "smb"];
    packages = with pkgs; [
      #etc
    ];

    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBnb1wEsZL/wmWOisNeT3oEoiP0LnmEd/NVQ3RwJ4rER sia@strongbox"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGYWPtuzgxIuDlKRe4XDQdYPu9N8vAijzCe4GyW8JXxl sia@eyestrainer"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEtKqGytooa5gHF/3799sFc4zWJ96B4HZlfkjLjomDO5 sia@chafebookpro"
    ];
  };
  users.groups.smb = {};
  users.users.smbuser = {
    isNormalUser = true;
    description = "Samba user";
    home = "/home/smbuser";
    createHome = true;

    # Groups this user belongs to
    extraGroups = [ "users" "smb" ];

    # Optional: if you want SSH or local login
    shell = pkgs.bashInteractive;
  };
/* ############################### NETWORKING ############################### */
  # needed for k3s setup
  networking.firewall.allowedTCPPorts = [ 80 443 22 6443 10250 53 7912 9100 2049 ];
  networking.firewall.allowedUDPPorts = [ 80 443 53 8472 2049 ];
  #networking.nat.enable = true;
  #networking.nat.internalInterfaces = [ "cni0" ];
  services.resolved.enable = false;
  networking.nameservers = [ "192.168.0.251" "1.1.1.1" "8.8.8.8" ];

  

  /* ########################################################################## */
  /*                                  SERVICES                                  */
  /* ########################################################################## */

  /* ################################### SSH ################################## */
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

  /* ################################### ZFS ################################## */
  services.zfs = {
    autoScrub.enable = true;
  };


  # This is needed to make sure that ZFS ARC isn't killing all my ram
  boot.kernelParams = [
    "zfs_arc_max=8589934592" # 8 GiB
  ];

  boot.extraModprobeConfig = ''
    options zfs zfs_arc_max=8589934592
    options zfs zfs_arc_min=1073741824
  '';

  /* ################################## Samba ################################# */

  services.samba = {
    enable = true;

    # Optional but strongly recommended
    openFirewall = true;

    settings = {
      global = {
        workgroup = "WORKGROUP";
        serverString = "nixos-samba";
        security = "user";

        # Good defaults for modern clients
        serverMinProtocol = "SMB2";
        serverMaxProtocol = "SMB3";

        # Performance / sanity
        socketOptions = "TCP_NODELAY IPTOS_LOWDELAY";
        useSendfile = "yes";
      };

      # Example share
      media = {
        path = "/tank/media";
        browseable = "yes";
        readOnly = "no";
        guestOk = "no";
        createMask = "0664";
        directoryMask = "0775";
      };
    };
  };

  services.avahi = {
    enable = true;
    nssmdns = true;
    openFirewall = true;
  };
  
  /* ######################## PROMETHEUS NODE EXPORTER ######################## */
  services.prometheus.exporters.node = {
    enable = true;
    port = 9100;
    enabledCollectors = [
      "logind"
      "systemd"
    ];
    openFirewall = true;
    firewallFilter = "-i br0 -p tcp -m tcp --dport 9100";
  };


  boot.zfs.devNodes = "/dev/disk/by-id";

  /* ################################### NFS ################################## */
  services.nfs.server = {
    enable = true;

    exports = ''
      /tank/media  *(rw,sync,no_subtree_check,no_root_squash)
    '';
  };

  # NFS needs RPC services
  services.rpcbind.enable = true;


  /* ########################################################################## */
  /*                                   SECRETS                                  */
  /* ########################################################################## */
  # This line is added so that it's not using /etc/ssh/ssh_host_key
  age.identityPaths = [ "/home/kian/.ssh/id_ed25519" ];

  age.secrets.zfs-tank-key = {
    file = ../secrets/zfs-tank-key.age;
    path = "/etc/zfs-tank-key";
    mode = "0400";
    owner = "root";
  };


}

