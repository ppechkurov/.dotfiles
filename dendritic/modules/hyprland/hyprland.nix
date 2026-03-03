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

      wayland.windowManager.hyprland.settings.input = with lib; {
        kb_layout = mkDefault "us,ru,us";
        kb_variant = mkDefault "dvorak,,basic";
        kb_options =
          mkDefault "grp:alt_shift_toggle,caps:escape"; # switch layout
        repeat_delay = mkDefault "250";
        repeat_rate = mkDefault "45";
      };
    };
}
