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
          inputs.agenix.nixosModules.default
          {
            networking.hostName = name;
            nixpkgs.hostPlatform = lib.mkDefault system;
          }
        ];
        specialArgs = {
          pkgs-unstable = inputs.nixpkgs-unstable.legacyPackages.${system};
        };
      };
    };
  };
}
