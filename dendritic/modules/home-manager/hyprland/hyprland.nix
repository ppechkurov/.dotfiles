{ ... }: {
  flake.modules.homeManager.hyprland = { lib, config, pkgs, ... }:
    let
      HP = "DP-1";
      samsung = "DVI-D-1";
      TV = "HDMI-A-1";
    in with lib; {
      home.packages = with pkgs; [ wf-recorder wl-clipboard xdg-utils ];

      wayland.windowManager.hyprland.enable = true;
      wayland.windowManager.hyprland = {
        xwayland.enable = true;
        systemd.variables = [ "--all" ];
        portalPackage = pkgs.xdg-desktop-portal-hyprland;
      };

      wayland.windowManager.hyprland.settings.input = {
        kb_layout = mkDefault "us,ru,us";
        kb_variant = mkDefault "dvorak,,basic";
        kb_options =
          mkDefault "grp:alt_shift_toggle,caps:escape"; # switch layout
        repeat_delay = mkDefault "250";
        repeat_rate = mkDefault "45";
      };

      wayland.windowManager.hyprland.settings.monitor = mkDefault [
        "${HP}, preferred, 0x0, 1"
        "${samsung}, preferred, 1920x0, 1"
        "${TV}, preferred, 0x-1080, 1"
      ];

      wayland.windowManager.hyprland.settings.workspace = mkDefault [
        # left
        "1, monitor:${HP}, default:true"
        "2, monitor:${HP}"
        "3, monitor:${HP}"
        "4, monitor:${HP}"
        "5, monitor:${HP}"

        # right
        "6, monitor:${samsung}, default:true"
        "7, monitor:${samsung}"
        "8, monitor:${samsung}"
        "9, monitor:${samsung}"
        "10, monitor:${samsung}"
      ];
    };
}
