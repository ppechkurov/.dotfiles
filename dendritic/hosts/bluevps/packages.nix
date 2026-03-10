{ inputs, ... }: {
  flake.modules.nixos.bluevps = { pkgs, pkgs-unstable, ... }: {
    environment.systemPackages = with pkgs;
      [
        #
      ];
  };
}
