{ inputs, pkgs, ... }: {
  programs.tmux.enable = true;
  programs.tmux = {
    baseIndex = 1;
    clock24 = true;
    escapeTime = 1;
    keyMode = "vi";
    historyLimit = 10000;
    mouse = true;
    plugins = with pkgs; [
      {
        plugin = tmuxPlugins.fzf-tmux-url;
        extraConfig = ''
          bind U run "cut -c3- '#{TMUX_CONF}' | sh -s _urlview '#{pane_id}'"
        '';
      }
      { plugin = inputs.minimal-tmux.packages.${pkgs.system}.default; }
    ];
    extraConfig = ''
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
      set -g @minimal-tmux-status-right "#[bg=default,fg=default,bold] #h  "

      set -g renumber-windows on    # renumber windows when a window is closed
      set -g set-titles on          # set terminal title

      bind -n C-l send-keys C-l \; run 'sleep 0.2' \; clear-history
    '';
  };
}
