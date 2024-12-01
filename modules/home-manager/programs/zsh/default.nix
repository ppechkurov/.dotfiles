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
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    defaultKeymap = "viins";
    antidote = {
      enable = true;
      plugins = [ "romkatv/powerlevel10k" "zsh-users/zsh-completions" ];
    };
    plugins = [{
      name = "vi-mode";
      src = pkgs.zsh-vi-mode;
      file = "share/zsh-vi-mode/zsh-vi-mode.plugin.zsh";
    }];
    oh-my-zsh = {
      enable = true;
      plugins = [ "fzf" ];
    };
    history = { ignoreAllDups = true; };
    shellAliases = {
      cat = "bat";
      ls = "eza --group-directories-first";
      ll = "ls -l -g --icons=auto";
      lla = "ll -a";
    };

    initExtra = # bash
      ''
        bindkey -s "^J" ""
        bindkey -s "^F" "tmux-sessionizer\n"

        source ~/.p10k.zsh
        SF_AC_ZSH_SETUP_PATH=${config.home.homeDirectory}/.cache/sf/autocomplete/zsh_setup && test -f $SF_AC_ZSH_SETUP_PATH && source $SF_AC_ZSH_SETUP_PATH; # sf autocomplete setup

        if [ -x "$(command -v kubectl)" ]; then
          source <(kubectl completion zsh)
        fi

        if [ -x "$(command -v aws)" ]; then
          complete -C "$(which aws_completer)" aws
        fi

        _ssh_custom() {
          local cur opts
          COMPREPLY=()
          cur="$\{COMP_WORDS[COMP_CWORD]}"
          opts=$(grep '^Host' ~/.ssh/config ~/.ssh/config.d/* 2>/dev/null | grep -v '[?*]' | cut -d ' ' -f 2-)

          COMPREPLY=("$(compgen -W "$opts" -- "$\{cur}")")
          return 0
        }

        complete -F _ssh_custom oil-ssh ssh

        # zsh-vi-mode overrides Ctrl+R, mapping it back
        function zvm_after_init() {
          zvm_bindkey viins "^R" fzf-history-widget
        }
      '';

    envExtra = # bash
      ''
        # VIM as man pager
        export MANPAGER="nvim -c 'Man!' -o -"

        # disable cursor style for zsh-vi-mode plugin
        export ZVM_CURSOR_STYLE_ENABLED=false
      '';
  };

  home.file.".p10k.zsh" = {
    enable = true;
    source = ./.p10k.zsh;
  };
}
