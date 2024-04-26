{ pkgs, ... }: {
  imports = [ (import ./settings.nix) ];
  config = {
    programs.waybar = {
      enable = true;
      package = pkgs.waybar.overrideAttrs (oa: {
        mesonFlags = (oa.mesonFlags or [ ]) ++ [ "-Dexperimental=true" ];
      });
      style = ./style.css;
    };
  };
}
