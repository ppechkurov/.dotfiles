{ inputs, ... }: {
  flake.modules.nixos.walker = { lib, ... }: {
    imports = [ inputs.walker.nixosModules.default ];

    programs.walker.enable = true;
  };
}
