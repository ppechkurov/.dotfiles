{ ... }: {
  wayland.windowManager.hyprland.settings = {
    # fck nvidia
    render = { explicit_sync = 1; };
    opengl = { nvidia_anti_flicker = true; };
  };
}

