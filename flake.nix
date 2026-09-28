{
  description = "Modular and reusable NixOS + Home Manager Flake with Hyprland (Lua) & dynamic theming";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zap = {
      url = "github:luth9r/zap";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, zap, ... }@inputs:
    let
      system = "x86_64-linux";
      vars = import ./vars.nix;
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      # Standalone NixOS config (uses default vars.nix — for CI / quick testing)
      nixosConfigurations = {
        ${vars.hostname} = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs vars; };
          modules = [
            ./hosts/nixos
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.backupFileExtension = "backup";
              home-manager.extraSpecialArgs = { inherit inputs vars; };
              home-manager.sharedModules = [
                zap.homeManagerModules.default
              ];
              home-manager.users.${vars.username} = import ./home/luther;
            }
          ];
        };
      };

      # Reusable modules for private flakes
      # Usage: inputs.dotfiles.nixosModules.default
      nixosModules.default = import ./hosts/common;

      # Usage: inputs.nixosConfig.homeManagerModules.default
      homeManagerModules.default = { ... }: {
        imports = [
          zap.homeManagerModules.default
          (import ./home/luther)
        ];
      };
    };
}
