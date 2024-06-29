{ pkgs, config, ... }: {
  home = { packages = with pkgs; [ bat eza ]; };

  programs.direnv.enable = true;
  programs.direnv.enableZshIntegration = true;

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableAutosuggestions = true;
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
      SF_AC_ZSH_SETUP_PATH=${config.home.homeDirectory}/.cache/sf/autocomplete/zsh_setup && test -f $SF_AC_ZSH_SETUP_PATH && source $SF_AC_ZSH_SETUP_PATH; # sf autocomplete setup
      complete -C "$(which aws_completer)" aws
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
