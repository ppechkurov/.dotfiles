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

    initContent = # bash
      ''
        bindkey -s "^J" ""
        bindkey -s "^F" "tmux-sessionizer\n"

        source ~/.p10k.zsh
        # SF_AC_ZSH_SETUP_PATH=${config.home.homeDirectory}/.cache/sf/autocomplete/zsh_setup && test -f $SF_AC_ZSH_SETUP_PATH && source $SF_AC_ZSH_SETUP_PATH; # sf autocomplete setup

        if [ -x "$(command -v kubectl)" ]; then
          source <(kubectl completion zsh)
        fi

        if [ -x "$(command -v minikube)" ]; then
          source <(minikube completion zsh)
        fi

        if [ -x "$(command -v aws)" ]; then
          complete -C "$(which aws_completer)" aws
        fi

        if [ -x "$(command -v tfschema)" ]; then
          complete -o nospace -C $(which tfschema) tfschema
        fi

        notify() {
          local dir=$(basename "$PWD")
          local cmd="$*"

          if command "$@"; then
            notify-send \
              --app-name "$dir" \
              "🟢 Success!" \
              $'cmd: '"$cmd"
            return
          fi

          exit_code=$?
          notify-send \
            --app-name "$dir" \
            --urgency critical \
            "🔴 Failure!" \
            $'cmd: '"$cmd"
          return $exit_code
        }

        _notify() {
          _arguments '*:: :_normal'
        }

        compdef _notify notify

        complete -F _ssh oil-ssh

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
