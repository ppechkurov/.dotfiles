{
  description = "My NixOS config flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager/release-24.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";
    agenix.inputs.darwin.follows = "";

    minimal-tmux.url = "github:niksingh710/minimal-tmux-status";
    mailserver.url =
      "gitlab:simple-nixos-mailserver/nixos-mailserver/nixos-24.11";

    jira.url = "git+ssh://git@github.com/ppechkurov/jira.git";
  };

  outputs = { self, nixpkgs, agenix, nixpkgs-unstable, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in {
      nixosConfigurations = let
        specialArgs = {
          inherit inputs;
          pkgs-unstable = import nixpkgs-unstable {
            inherit system;
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
            inputs.agenix.nixosModules.default
            ({ ... }: {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
            })
          ];
          inherit specialArgs;
        };
        vps = nixpkgs.lib.nixosSystem {
          modules = [
            ./hosts/vps/configuration.nix
            inputs.mailserver.nixosModule
            inputs.agenix.nixosModules.default
          ];
          inherit specialArgs;
        };
      };

      devShells = {
        ${system}.default = pkgs.mkShell {
          packages = [ inputs.agenix.packages.${system}.agenix ];
        };
      };
    };
}
