{
  description = "NixOS config for homelab machines";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
  inputs.agenix.url = "github:ryantm/agenix";
  inputs.sops-nix.url = "github:Mic92/sops-nix";
  inputs.sops-nix.inputs.nixpkgs.follows = "nixpkgs";

  outputs = { self, nixpkgs, agenix, sops-nix }: {
    specialArgs = {
      inherit self;
    };
    nixosConfigurations = {
      homelab-node-0 = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./modules/k3s-common.nix
          ./hosts/homelab-node-0.nix
          agenix.nixosModules.default
          sops-nix.nixosModules.sops
          {
            environment.systemPackages = [ agenix.packages.x86_64-linux.default ];
          }
        ];
      };

      homelab-node-1 = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./modules/k3s-common.nix
          ./hosts/homelab-node-1.nix
          agenix.nixosModules.default
          sops-nix.nixosModules.sops
          {
            environment.systemPackages = [ agenix.packages.x86_64-linux.default ];
          }
        ];
      };
    };
    packages.x86_64-linux.default = self.nixosConfigurations.homelab-node-0.config.system.build.toplevel;
  };
}