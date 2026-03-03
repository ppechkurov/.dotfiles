{ self, ... }: {
  flake.modules.homeManager.cli = {
    imports = with self.modules.homeManager; [
      aerc
      atuin
      foot
      fzf
      gh
      git
      mycli
      tmux
      tofi
      yazi
      zoxide
      zsh
    ];

    programs.htop.enable = true;
  };
}
