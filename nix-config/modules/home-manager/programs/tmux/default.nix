{ pkgs, ... }:
let
  theme = {
    thm_bg = "#1e1e2e";
    thm_fg = "#cdd6f4";
    thm_cyan = "#89dceb";
    thm_black = "#181825";
    thm_gray = "#313244";
    thm_magenta = "#cba6f7";
    thm_pink = "#f5c2e7";
    thm_red = "#f38ba8";
    thm_green = "#a6e3a1";
    thm_yellow = "#f9e2af";
    thm_blue = "#89b4fa";
    thm_orange = "#fab387";
    thm_black4 = "#585b70";
  };
in {
  programs.tmux.enable = true;
  programs.tmux = {
    baseIndex = 1;
    clock24 = true;
    escapeTime = 1;
    keyMode = "vi";
    historyLimit = 10000;
    mouse = true;
    plugins = with pkgs; [{
      plugin = tmuxPlugins.fzf-tmux-url;
      extraConfig = ''
        bind U run "cut -c3- '#{TMUX_CONF}' | sh -s _urlview '#{pane_id}'"
      '';
    }];
    extraConfig = with theme; ''
      set -g default-terminal "screen-256color"
      set -g pane-border-style fg=blue
      set -g pane-active-border-style "bg=default fg=blue"

      bind Enter copy-mode

      bind -n C-k copy-mode \; send-keys -X halfpage-up
      bind -n C-j copy-mode \; send-keys -X halfpage-down

      bind-key -T copy-mode-vi C-k send-keys -X halfpage-up
      bind-key -T copy-mode-vi C-j send-keys -X halfpage-down
      bind-key -T copy-mode-vi v send-keys -X begin-selection
      bind-key -T copy-mode-vi C-v send-keys -X begin-selection \; send-keys -X rectangle-toggle

      set -g status "on"
      set -g status-bg "${thm_red}"
      set -g status-justify "left"
      set -g status-left-length "100"
      set -g status-right-length "100"

      set -g renumber-windows on    # renumber windows when a window is closed
      set -g set-titles on          # set terminal title

      bind -n C-l send-keys C-l \; run 'sleep 0.2' \; clear-history

      tmux_conf_theme_left_separator_main='\uE0B0'  # /!\ you don't need to install Powerline
      tmux_conf_theme_left_separator_sub='\uE0B1'   #   you only need fonts patched with
      tmux_conf_theme_right_separator_main='\uE0B2' #   Powerline symbols or the standalone
      tmux_conf_theme_right_separator_sub='\uE0B3'  #   PowerlineSymbols.otf font, see README.md
    '';
  };
}
