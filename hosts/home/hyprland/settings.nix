{ ... }: {
  wayland.windowManager.hyprland.settings = {
    decoration = { drop_shadow = false; };
    misc = { no_direct_scanout = false; };
    opengl = { nvidia_anti_flicker = true; };
  };
}

