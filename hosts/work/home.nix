{ pkgs, ... }: {
  imports = [ ../../modules/home-manager ./hyprland ];

  xdg.configFile.hypr = {
    enable = true;
    source = ./hackerman-wallpapers.jpg;
    target = "hypr/hackerman-wallpapers.jpg";
  };

  home.sessionPath = [ "$HOME/.npm-global/bin" ];
  home.packages = with pkgs; [ drawio just obsidian zoom-us ];

  programs.git.extraConfig = {
    user.signingkey = "F7C0B35DA9397DD1";
    commit.gpgsign = true;
  };

  local.zellij.enable = true;
  local.mysql.enable = true;
}
