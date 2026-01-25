{ inputs, self, ... }:
let
  system = "x86_64-linux";
  pkgs-unstable = import inputs.nixpkgs-unstable {
    inherit system;
    config.allowUnfree = true;
  };
in {
  flake.deploy.nodes = let
    mkDeployNode = { name, hostname ? name, sshUser ? "root" }: {
      ${name} = {
        inherit hostname;
        profiles.system = {
          inherit sshUser;
          path = inputs.deploy-rs.lib.${system}.activate.nixos
            self.nixosConfigurations.${name};
        };
      };
    };
  in mkDeployNode {
    name = "mini";
    hostname = "mini.local.wg";
  } // mkDeployNode { name = "webdock"; } // mkDeployNode { name = "bluevps"; };
  flake.nixosConfigurations = let
    globals = import ../globals.nix;
    specialArgs = { inherit inputs globals pkgs-unstable; };

    homeManagerConfig = { ... }: {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
    };

    mkRegularHost = configModulePath: extraModules:
      inputs.nixpkgs.lib.nixosSystem {
        modules = [
          configModulePath
          inputs.home-manager.nixosModules.home-manager
          inputs.agenix.nixosModules.default
          homeManagerConfig
        ] ++ extraModules;
        inherit specialArgs;
      };

    mkVps = hostname: configModulePath:
      inputs.nixpkgs.lib.nixosSystem {
        modules = [
          ./vps
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
    work = mkRegularHost ./work/configuration.nix [ ];
    home = mkRegularHost ./home [
      ../modules/nixos/common
      ../modules/nixos/nvidia
      ../modules/nixos/wireguard
      ../modules/nixos/networks/kubernetes.nix
      ../modules/nixos/services/syncthing.nix
      ../modules/nixos/services/gatus.nix
      ../modules/nixos/services/mattermost
    ];
    mini = mkRegularHost ./mini/configuration.nix [ ];
    kirill = mkRegularHost ./kirill/configuration.nix [
      ../modules/nixos/common
      # ../modules/nixos/wireguard
      ../modules/nixos/services/mattermost
    ];

    bluevps = mkVps "bluevps" ./vps/bluevps/configuration.nix;
    # senko = mkVps "senko" ./senko/configuration.nix;
    webdock = mkVps "webdock" ./vps/webdock/configuration.nix;
  };
}

