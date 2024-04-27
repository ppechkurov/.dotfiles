{
  imports = [ ../../modules/home-manager ];

  xdg.configFile.sway = {
    enable = true;
    source = ./hackerman-wallpapers.jpg;
    target = "sway/hackerman-wallpapers.jpg";
  };
}
