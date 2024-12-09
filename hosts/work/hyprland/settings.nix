{ ... }: {
  wayland.windowManager.hyprland.settings = {
    decoration.shadow.enabled = false;
    render.direct_scanout = true;
  };
}
