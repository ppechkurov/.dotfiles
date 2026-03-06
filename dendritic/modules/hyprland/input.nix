{
  flake.modules.homeManager.hyprland = { lib, ... }: {
    wayland.windowManager.hyprland.settings.input = with lib; {
      kb_layout = mkDefault "us,ru";
      kb_variant = mkDefault "dvorak,";
      kb_options = mkDefault "grp:alt_shift_toggle,caps:escape"; # switch layout
      repeat_delay = mkDefault "250";
      repeat_rate = mkDefault "45";
    };
  };
}
