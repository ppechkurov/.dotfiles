{ ... }: {
  imports = [
    ../../modules/home-manager/programs/nvim
    ../../modules/home-manager/programs/zsh
    ../../modules/home-manager/programs/atuin
    ../../modules/home-manager/programs/tmux
    ../../modules/home-manager/keyboard
  ];

  home = { packages = [ ]; };

  home.stateVersion = "25.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.htop.enable = true;

  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      createDirectories = true;
    };
  };
}

