{ self, ... }: {
  flake.modules.nixos.hyprland = { pkgs, pkgs-unstable, ... }: {
    programs.hyprland.enable = true;
    programs.hyprland.xwayland.enable = true;
    programs.hyprland.portalPackage = pkgs.xdg-desktop-portal-hyprland;
  };

  flake.modules.homeManager.hyprland =
    { lib, config, pkgs, pkgs-unstable, ... }: {
      imports = with self.modules.homeManager; [ hypridle hyprpaper ];

      home.packages = with pkgs; [
        wf-recorder
        wl-clipboard
        xdg-utils
        hyprland-per-window-layout
        wlr-which-key
        pkgs-unstable.hyprshutdown
      ];

      wayland.windowManager.hyprland.enable = true;
      wayland.windowManager.hyprland = {
        xwayland.enable = true;
        systemd.variables = [ "--all" ];
        portalPackage = pkgs.xdg-desktop-portal-hyprland;
      };
    };
}
