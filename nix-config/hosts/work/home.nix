{ pkgs, ... }: {
  imports = [ ../../modules/home-manager ./hyprland ];

  xdg.configFile.hypr = {
    enable = true;
    source = ./hackerman-wallpapers.jpg;
    target = "hypr/hackerman-wallpapers.jpg";
  };

  home.sessionPath = [ "$HOME/.npm-global/bin" ];
  home.packages = with pkgs; [ zoom-us ];

  local.zellij.enable = true;
  local.mysql.enable = true;
}
