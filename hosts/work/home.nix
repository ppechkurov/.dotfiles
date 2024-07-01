{ pkgs, ... }: {
  imports = [ ../../modules/home-manager ./hyprland ];

  xdg.configFile.hypr = {
    enable = true;
    source = ./hackerman-wallpapers.jpg;
    target = "hypr/hackerman-wallpapers.jpg";
  };

  home.sessionPath = [ "$HOME/.npm-global/bin" ];
  home.packages = with pkgs; [
    zoom-us
    ansible
    obsidian
    just
    protonvpn-gui
    drawio
  ];

  local.zellij.enable = true;
  local.mysql.enable = true;

  local.meli.enable = true;
  local.meli.email = "petr.pechkurov@succraft.com";
  local.meli.secrets_path = "success/gmail";
}
