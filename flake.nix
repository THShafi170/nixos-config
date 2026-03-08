{
  description = "tenshou170's NixOS configuration";

  inputs = {
    # Repositories
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-master.url = "github:NixOS/nixpkgs/master";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";

    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-alien = {
      url = "github:thiagokokada/nix-alien";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    aagl = {
      url = "github:ezKEa/aagl-gtk-on-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    bottles-deflatpak.url = "github:THShafi170/Bottles-Deflatpak";

    nixos-06cb-009a-fingerprint-sensor = {
      url = "github:iedame/nixos-06cb-009a-fingerprint-sensor/25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-flatpak.url = "github:gmodena/nix-flatpak";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      nix-cachyos-kernel,
      aagl,
      bottles-deflatpak,
      ...
    }@inputs:
    let
      system = "x86_64-linux";

      # Centralized nixpkgs configuration
      nixpkgsConfig = {
        allowUnfree = true;
      };

      # Helper to instantiate nixpkgs with our global config
      mkPkgs =
        input:
        import input {
          inherit system;
          config = nixpkgsConfig;
        };

      pkgsMaster = mkPkgs inputs.nixpkgs-master;
    in
    {
      nixosConfigurations."X1-Yoga-2nd" = nixpkgs.lib.nixosSystem {
        inherit system;

        modules = [
          ./hosts/default.nix
          aagl.nixosModules.default
          inputs.nixos-06cb-009a-fingerprint-sensor.nixosModules."06cb-009a-fingerprint-sensor"
          inputs.home-manager.nixosModules.home-manager
          inputs.nix-flatpak.nixosModules.nix-flatpak

          # Configure nixpkgs
          {
            nixpkgs = {
              config = nixpkgsConfig;
            };
          }

          # Home Manager configuration
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              backupFileExtension = "bak";
              users.tenshou170 = import ./home/default.nix;
              extraSpecialArgs = {
                inherit
                  aagl
                  inputs
                  pkgsMaster
                  ;
              };
            };
          }
        ];

        # Pass inputs through specialArgs
        specialArgs = {
          inherit
            self
            aagl
            inputs
            pkgsMaster
            ;
        };
      };
    };
}
