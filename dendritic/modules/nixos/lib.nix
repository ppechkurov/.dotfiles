{ inputs, self, lib, ... }:
let modules = self.modules;
in {
  options.flake.lib = lib.mkOption {
    type = lib.types.attrsOf lib.types.unspecified;
    default = { };
  };

  config.flake.lib = {
    mkNixos = system: name: {
      ${name} = inputs.nixpkgs.lib.nixosSystem {
        modules = [
          modules.nixos.base
          modules.nixos."${name}-configuration"
          modules.nixos."${name}-hardware-configuration"
          { nixpkgs.hostPlatform = lib.mkDefault system; }
        ];
      };
    };

    mkHomeManager = system: name:
      let
        home-manager-config = { lib, ... }: {
          home-manager = {
            verbose = true;
            useUserPackages = true;
            useGlobalPkgs = true;
            backupFileExtension = "backup";
            backupCommand = "rm";
            overwriteBackup = true;
          };
        };
      in {
        ${name} = inputs.home-manager.lib.homeManagerConfiguration {
          pkgs = inputs.nixpkgs.legacyPackages.${system};
          pkgs-unstable = inputs.nixpkgs-unstable.legacyPackages.${system};
          modules = [
            modules.homeManager.${name}
            (inputs.home-manager.nixosModules.home-manager home-manager-config)
          ];
        };
      };
  };
}

