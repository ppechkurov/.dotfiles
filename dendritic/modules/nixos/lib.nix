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
          {
            networking.hostName = name;
            nixpkgs.hostPlatform = lib.mkDefault system;
          }
        ];
      };
    };

    mkHomeManager = system: name: {
      ${name} = inputs.home-manager.lib.homeManagerConfiguration {
        pkgs = inputs.nixpkgs.legacyPackages.${system};
        pkgs-unstable = inputs.nixpkgs-unstable.legacyPackages.${system};
        modules = [ modules.homeManager.${name} ];
      };
    };

    mkUser = name:
      { pkgs, ... }: {
        programs.zsh.enable = true;
        users.users.${name} = {
          description = "Petr Pechkurov";
          extraGroups = [ "wheel" "disk" "power" ];
          isNormalUser = true;
          shell = pkgs.zsh;
        };
      };
  };
}
