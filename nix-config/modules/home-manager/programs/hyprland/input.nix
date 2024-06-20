{ ... }: {
  wayland.windowManager.hyprland.settings.input = {
    kb_layout = "us,ru";
    # kb_layout = "us,ru,us";
    kb_variant = "dvorak,,basic";
    kb_options = "grp:alt_shift_toggle,caps:escape"; # switch layout
    repeat_delay = "250";
    repeat_rate = "45";
  };
}
