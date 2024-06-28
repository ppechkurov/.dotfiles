{
  description = "My NixOS config flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/release-24.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    minimal-tmux.url = "github:niksingh710/minimal-tmux-status";
    minimal-tmux.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, ... }@inputs: {
    nixosConfigurations = let
      pkgs-unstable = import nixpkgs-unstable {
        system = "x86_64-linux";
        config = { allowUnfree = true; };
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
        specialArgs = {
          inherit inputs;
          inherit pkgs-unstable;
        };
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
        specialArgs = { inherit inputs; };
      };
    };
  };
}
