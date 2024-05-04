{
  imports = [ ../../modules/home-manager ];

  wayland.windowManager.sway.config = {
    input = {
      "type:keyboard" = {
        xkb_layout = "us,ru";
        xkb_variant = "real-prog-dvorak,";
      };
    };
  };
}
