{
  flake.modules.homeManager.hyprpaper = { ... }: {
    services.hyprpaper.enable = true;
    services.hyprpaper.settings = {
      ipc = "on";
      splash = true;
      splash_offset = 2.0;
      preload = [ "~/.config/hypr/hackerman-wallpapers.jpg" ];
      wallpaper = [ ",~/.config/hypr/hackerman-wallpapers.jpg" ];
    };
  };
}
