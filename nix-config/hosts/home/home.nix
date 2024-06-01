{ inputs, ... }: {

  imports = [ ../../modules/home-manager ];

  xdg.configFile.sway = {
    enable = true;
    source = ./hackerman-wallpapers.jpg;
    target = "sway/hackerman-wallpapers.jpg";
  };

  wayland.windowManager.sway.config = {
    input = {
      "type:keyboard" = {
        xkb_layout = "us,ru,us";
        xkb_variant = "dvorak,,basic";
      };
    };
  };
}
