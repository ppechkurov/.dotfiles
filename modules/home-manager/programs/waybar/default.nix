{ pkgs, ... }: {
  config = {
    programs.waybar = {
      enable = true;
      package = pkgs.waybar.overrideAttrs (oa: {
        mesonFlags = (oa.mesonFlags or [ ]) ++ [ "-Dexperimental=true" ];
      });
      settings = import ./settings.nix;
      style = ./style.css;
    };
  };
}
