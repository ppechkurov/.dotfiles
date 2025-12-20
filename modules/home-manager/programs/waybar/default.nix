{ inputs, pkgs, ... }: {
  config = {
    programs.waybar = let
      waybar = pkgs.waybar;
      #   inputs.waybar.packages.${pkgs.stdenv.hostPlatform.system}.default;
    in {
      enable = true;
      package = waybar;

      settings = import ./settings.nix;
      style = ./style.css;
    };
  };
}
