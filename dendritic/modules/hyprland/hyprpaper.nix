{
  flake.modules.homeManager.hyprpaper = { config, ... }: {
    services.hyprpaper.enable = true;
    services.hyprpaper.settings = {
      ipc = "on";
      splash = true;
      splash_offset = 2;
      preload = [ "~/.config/hypr/hackerman-wallpapers.jpg" ];
      wallpaper = [ ",~/.config/hypr/hackerman-wallpapers.jpg" ];
    };

    xdg.configFile.hypr = {
      enable = true;
      source = config.lib.file.mkOutOfStoreSymlink ./hackerman-wallpapers.jpg;
      target = "hypr/hackerman-wallpapers.jpg";
    };
  };
}
