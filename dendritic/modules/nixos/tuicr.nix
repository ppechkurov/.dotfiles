{ inputs, ... }: {
  flake.modules.nixos.tuicr = { pkgs, pkgs-unstable, ... }: {
    environment.systemPackages =
      let
        system = pkgs.stdenv.hostPlatform.system;
        tuicr = inputs.tuicr.packages.${system}.default;
      in
      [
        tuicr
      ];
  };
}
