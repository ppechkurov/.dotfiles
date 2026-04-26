{
  flake.modules.homeManager.foot = {
    programs.foot.enable = true;
    programs.foot = {
      settings = {
        main = {
          font = "JetBrainsMono Nerd Font:size=14";
          selection-target = "both";
        };
        mouse = { hide-when-typing = "yes"; };
        cursor = { blink = "yes"; };
        key-bindings = {
          scrollback-up-half-page = "Control+k";
          scrollback-down-half-page = "Control+j";
          show-urls-launch = "Control+Shift+u";
          unicode-input = "none";

          pipe-command-output = ''[sh -c "cat - | wl-copy"] Control+Shift+g'';

          prompt-prev = "Control+Shift+k";
          prompt-next = "Control+Shift+j";
          # search-start = "Control+slash";
        };
        search-bindings = {
          find-prev = "Control+n";
          find-next = "Control+Shift+n";
        };
      };
    };

    programs.zsh.initContent = # bash
      ''
        function precmd {
          # Jumping between prompts
          print -Pn "\e]133;A\e\\"

          # Pipe cmd outputs
          if ! builtin zle; then
            print -n "\e]133;D\e\\"
          fi
        }

        function preexec {
          print -n "\e]133;C\e\\"
        }
      '';
  };
}

