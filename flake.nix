{
  description = "My NixOS config flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/release-24.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    minimal-tmux.url = "github:niksingh710/minimal-tmux-status";
    minimal-tmux.inputs.nixpkgs.follows = "nixpkgs";
    jira.url = "github:ppechkurov/jira";
    jira.inputs.nixpkgs.follows = "nixpkgs-unstable";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, ... }@inputs: {
    nixosConfigurations = let
      specialArgs = {
        inherit inputs;
        pkgs-unstable = import nixpkgs-unstable {
          system = "x86_64-linux";
          config = { allowUnfree = true; };
        };
      };
    in {
      work = nixpkgs.lib.nixosSystem {
        modules = [
          ./hosts/work/configuration.nix
          inputs.home-manager.nixosModule
          ({ ... }: {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
          })
        ];
        inherit specialArgs;
      };
      home = nixpkgs.lib.nixosSystem {
        modules = [
          ./hosts/home/configuration.nix
          inputs.home-manager.nixosModule
          ({ ... }: {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
          })
        ];
        inherit specialArgs;
      };
    };
  };
}
