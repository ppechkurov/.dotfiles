{
  description = "My NixOS config flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-23.11";
    home-manager.url = "github:nix-community/home-manager/release-23.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, ... }@inputs: {
    nixosConfigurations = {
      work = nixpkgs.lib.nixosSystem {
        modules = [
          ./hosts/work/configuration.nix
          inputs.home-manager.nixosModule
          ({ ... }: {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
          })
        ];
        specialArgs = { inherit inputs; };
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
