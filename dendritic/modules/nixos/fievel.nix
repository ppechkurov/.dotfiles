{ inputs, ... }: {
  flake.modules.nixos.fievel = { pkgs, ... }: {
    imports = [ inputs.fievel.nixosModules.default ];

    services.fievel = {
      enable = true;
      users = [ "petrp" ];
    };
  };
}
