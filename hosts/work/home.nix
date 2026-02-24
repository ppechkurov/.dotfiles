{ pkgs, config, ... }: {
  imports = [ ../../modules/home-manager ./hyprland ];

  xdg.configFile.hypr = {
    enable = true;
    source = ./hackerman-wallpapers.jpg;
    target = "hypr/hackerman-wallpapers.jpg";
  };

  home.sessionPath = [ "$HOME/.npm-global/bin" ];
  home.packages = with pkgs; [ zoom-us slack signal-desktop ];

  programs.atuin.enable = true;
  programs.git.extraConfig = {
    user.signingkey = "F7C0B35DA9397DD1";
    commit.gpgsign = true;
  };

  xdg.configFile.noctalia = {
    enable = true;
    recursive = true;
    source = config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/.dotfiles/modules/home-manager/programs/noctalia";
  };

  local.zellij.enable = true;
  local.mysql.enable = true;
}
