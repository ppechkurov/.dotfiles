{
  flake.modules.homeManager.zsh = { pkgs, lib, ... }: {
    home.packages = with pkgs; [ bat eza fzf ];

    programs.direnv.enable = true;
    programs.direnv.enableZshIntegration = true;

    programs.zsh = let
      sound =
        "${pkgs.sound-theme-freedesktop}/share/sounds/freedesktop/stereo/complete.oga";
    in {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      defaultKeymap = "viins";
      plugins = [
        {
          name = "vi-mode";
          src = pkgs.zsh-vi-mode;
          file = "share/zsh-vi-mode/zsh-vi-mode.plugin.zsh";
        }
        {
          name = "powerlevel10k";
          src = pkgs.zsh-powerlevel10k;
          file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
        }
      ];
      oh-my-zsh = {
        enable = true;
        plugins = [ "fzf" ];
      };
      history = { ignoreAllDups = true; };
      shellAliases = {
        cat = "${lib.getExe pkgs.bat}";
        ls = "${lib.getExe pkgs.eza} --group-directories-first";
        ll = "ls -l -g --icons=auto";
        lla = "ll -a";
      };

      initContent = # bash
        ''
          bindkey -s "^J" ""
          bindkey -s "^F" "tmux-sessionizer\n"

          source ~/.p10k.zsh

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
              (pw-play "${sound}" &>/dev/null &)

              ${pkgs.libnotify}/bin/notify-send \
                --app-name "$dir" \
                "🟢 Success!" \
                $'cmd: '"$cmd"

              return
            fi

            exit_code=$?
            ${pkgs.libnotify}/bin/notify-send \
              --app-name "$dir" \
              --urgency critical \
              "🔴 Failure!" \
              $'cmd: '"$cmd"

            (pw-play "${sound}" &>/dev/null &)

            return $exit_code
          }

          _notify() {
            _arguments '*:: :_normal'
          }

          compdef _notify notify

          # zsh-vi-mode overrides Ctrl+R, mapping it back
          function zvm_after_init() {
            zvm_bindkey vicmd "^r" atuin-search
            bindkey '^r' atuin-search
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
  };
}
