{ inputs, pkgs, ... }: {
  config = {
    programs.waybar =
      let waybar = inputs.waybar.packages.${pkgs.system}.default;
      in {
        enable = true;
        package = waybar;

        settings = import ./settings.nix;
        style = ./style.css;
      };
  };
}
