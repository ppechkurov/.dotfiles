{ self, ... }: {
  flake.modules.homeManager.cli = {
    imports = with self.modules.homeManager; [
      atuin
      foot
      fzf
      git
      tmux
      yazi
      zoxide
      zsh
    ];

    programs.htop.enable = true;
  };
}
