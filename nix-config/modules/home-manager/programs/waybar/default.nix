{ pkgs, ... }: 
{
  imports =  [ (import ./settings.nix) ];

  programs.waybar = {
    enable = true;
    package = pkgs.waybar.overrideAttrs (oa: { mesonFlags = (oa.mesonFlags or [ ]) ++ [ "-Dexperimental=true" ]; });
    style = ./style.css;
  };
}
