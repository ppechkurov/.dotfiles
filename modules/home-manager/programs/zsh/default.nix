{ pkgs, config, ... }:
let
  oil-ssh = pkgs.writeScriptBin "oil-ssh" # bash
    ''
      host=$1
      [ -z "$host" ] && host=$(rg '^[[:space:]]*Host[[:space:]]+(\S+)' -o --replace '$1' ~/.ssh/config --no-line-number | fzf)
      [ "$host" ] && vim oil-ssh://"$host"//home
    '';
in {
  home = { packages = with pkgs; [ bat eza oil-ssh ]; };

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
      plugins = [ "romkatv/powerlevel10k" "zsh-users/zsh-completions" ];
    };
    oh-my-zsh = {
      enable = true;
      plugins = [ "vi-mode" "fzf" ];
    };

    history = { ignoreAllDups = true; };
    shellAliases = {
      cat = "bat";
      ls = "eza --group-directories-first";
      ll = "ls -l -g --icons=auto";
      lla = "ll -a";
    };

    initExtra =
      # bash
      ''
        source ~/.p10k.zsh
        SF_AC_ZSH_SETUP_PATH=${config.home.homeDirectory}/.cache/sf/autocomplete/zsh_setup && test -f $SF_AC_ZSH_SETUP_PATH && source $SF_AC_ZSH_SETUP_PATH; # sf autocomplete setup

        if [ -x "$(command -v kubectl)" ]; then
          source <(kubectl completion zsh)
        fi

        if [ -x "$(command -v aws)" ]; then
          complete -C "$(which aws_completer)" aws
        fi

        _ssh() {
          local cur opts
          COMPREPLY=()
          cur="$\{COMP_WORDS[COMP_CWORD]}"
          opts=$(grep '^Host' ~/.ssh/config ~/.ssh/config.d/* 2>/dev/null | grep -v '[?*]' | cut -d ' ' -f 2-)

          COMPREPLY=("$(compgen -W "$opts" -- "$\{cur}")")
          return 0
        }

        complete -F _ssh oil-ssh ssh scp
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
