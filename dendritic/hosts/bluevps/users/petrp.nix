let user = "petrp";
in {
  flake.modules.nixos.bluevps = { pkgs, lib, ... }: {
    users.users.${user}.shell = lib.mkForce pkgs.bash;

    nix.settings.trusted-users = [ user ];
  };
}
