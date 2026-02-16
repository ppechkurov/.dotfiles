{
  flake.modules.homeManager.waybar = { pkgs, ... }: {
    programs.waybar.enable = true;
    programs.waybar = { style = ./style.css; };
  };
}
