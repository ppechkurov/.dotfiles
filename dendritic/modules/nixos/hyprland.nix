{
  flake.modules.nixos.hyprland = { pkgs, pkgs-unstable, ... }: {
    programs.hyprland.enable = true;
    programs.hyprland.xwayland.enable = true;
    programs.hyprland.portalPackage = pkgs.xdg-desktop-portal-hyprland;

    environment.systemPackages = with pkgs; [
      hyprland-per-window-layout
      wlr-which-key
      pkgs-unstable.hyprshutdown
    ];
  };
}
