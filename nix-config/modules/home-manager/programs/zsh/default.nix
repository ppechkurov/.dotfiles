{ pkgs, inputs, ... }: {
  home = { packages = with pkgs; [ bat eza ]; };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableAutosuggestions = true;
    # autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
    defaultKeymap = "emacs";
    antidote = {
      enable = true;
      plugins = [ "romkatv/powerlevel10k" ];
    };
    oh-my-zsh = {
      enable = true;
      plugins = [ "vi-mode" "fzf" ];
    };

    history = { ignoreAllDups = true; };
    shellAliases = {
      cat = "bat";
      ls = "eza";
      ll = "ls -l -g --icons=auto";
      lla = "ll -a";
    };

    initExtra = ''
      source ~/.p10k.zsh
    '';

    envExtra = ''
      # VIM as man pager
      export MANPAGER="nvim -c 'Man!' -o -"
    '';
  };

  home.file.".p10k.zsh" = {
    enable = true;
    source = ./.p10k.zsh;
  };
}
