{
  description = "My NixOS config flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager/release-25.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";
    agenix.inputs.darwin.follows = "";

    minimal-tmux.url = "github:niksingh710/minimal-tmux-status";
    mailserver.url =
      "gitlab:simple-nixos-mailserver/nixos-mailserver/nixos-25.11";

    jira.url = "ssh://git@github.com/ppechkurov/jira.git";
    jira = {
      type = "git";
      ref = "refs/tags/v0.0.5";
    };

    dms = {
      url = "github:AvengeMedia/DankMaterialShell";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    gostman.url = "github:Halftoothed/gostman";
    gostman.inputs.nixpkgs.follows = "nixpkgs";

    # waybar.url = "github:Alexays/Waybar";
    # waybar.inputs.nixpkgs.follows = "nixpkgs-unstable";

    deploy-rs.url = "github:serokell/deploy-rs";
    deploy-rs.inputs.nixpkgs.follows = "nixpkgs-unstable";
  };

  outputs = { self, nixpkgs, agenix, nixpkgs-unstable, deploy-rs, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
      pkgs-unstable = import nixpkgs-unstable {
        inherit system;
        config = { allowUnfree = true; };
      };
      globals = import ./globals.nix;
    in {
      deploy.nodes = let
        mkDeployNode = { name, hostname ? name, sshUser ? "root" }: {
          ${name} = {
            inherit hostname;
            profiles.system = {
              inherit sshUser;
              path = deploy-rs.lib.${system}.activate.nixos
                self.nixosConfigurations.${name};
            };
          };
        };
      in mkDeployNode {
        name = "mini";
        hostname = "mini.local.wg";
      } // mkDeployNode { name = "webdock"; }
      // mkDeployNode { name = "bluevps"; };

      nixosConfigurations = let
        specialArgs = { inherit inputs globals pkgs-unstable; };
        mkVps = hostname: configModulePath:
          nixpkgs-unstable.lib.nixosSystem {
            modules = [
              ./hosts/vps
              configModulePath
              inputs.mailserver.nixosModule
              inputs.agenix.nixosModules.default
            ];
            specialArgs = specialArgs // {
              username = "petrp";
              inherit hostname;
            };
          };
      in {
        work = nixpkgs.lib.nixosSystem {
          modules = [
            ./hosts/work/configuration.nix
            inputs.home-manager.nixosModules.home-manager
            inputs.agenix.nixosModules.default
            inputs.dms.nixosModules.dank-material-shell
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
            inputs.home-manager.nixosModules.home-manager
            inputs.agenix.nixosModules.default
            ({ ... }: {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
            })
          ];
          inherit specialArgs;
        };
        mini = nixpkgs.lib.nixosSystem {
          modules = [
            ./hosts/mini/configuration.nix
            inputs.home-manager.nixosModules.home-manager
            inputs.agenix.nixosModules.default
            ({ ... }: {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
            })
          ];
          inherit specialArgs;
        };
        bluevps = mkVps "bluevps" ./hosts/vps/bluevps/configuration.nix;
        # senko = mkVps "senko" ./hosts/vps/senko/configuration.nix;
        webdock = mkVps "webdock" ./hosts/vps/webdock/configuration.nix;
      };

      devShells = {
        ${system}.default = pkgs.mkShell {
          packages =
            [ inputs.agenix.packages.${system}.agenix pkgs.nh pkgs.deploy-rs ];
        };
      };
    };
}
