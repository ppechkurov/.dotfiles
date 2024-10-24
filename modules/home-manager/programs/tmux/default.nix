{ inputs, pkgs, ... }: {
  programs.tmux.enable = true;
  programs.tmux = {
    baseIndex = 1;
    clock24 = true;
    customPaneNavigationAndResize = true;
    escapeTime = 1;
    historyLimit = 10000;
    keyMode = "vi";
    mouse = true;
    newSession = true;
    resizeAmount = 2;
    terminal = "screen-256color";
    plugins = with pkgs; [
      {
        plugin = tmuxPlugins.fzf-tmux-url;
        extraConfig = ''
          bind U run "cut -c3- '#{TMUX_CONF}' | sh -s _urlview '#{pane_id}'"
        '';
      }
      {
        plugin = inputs.minimal-tmux.packages.${pkgs.system}.default;
        extraConfig = ''
          set -g @minimal-tmux-status-right "#[bg=default,fg=default,bold] #S  "
        '';
      }
      {
        plugin = tmuxPlugins.resurrect;
        extraConfig = "set -g @resurrect-processes 'ssh cava ncmpcpp'";
      }
      {
        plugin = tmuxPlugins.continuum;
        extraConfig = "set -g @continuum-restore 'on'";
      }
    ];
    extraConfig = ''
      set -g pane-border-style fg=blue
      set -g pane-active-border-style "bg=default fg=blue"

      set -g status "on"

      set -g renumber-windows on    # renumber windows when a window is closed
      set -g set-titles on          # set terminal title

      bind -n C-Enter copy-mode

      bind-key -T copy-mode-vi v send -X begin-selection
      bind-key -T copy-mode-vi C-v send -X begin-selection \; send-keys -X rectangle-toggle
      bind-key -T copy-mode-vi y send -X copy-selection-and-cancel

      bind-key -T copy-mode-vi ? command-prompt -i -p "search down" "send -X search-forward-incremental \"%%%\""
      bind-key -T copy-mode-vi / command-prompt -i -p "search up" "send -X search-backward-incremental \"%%%\""

      bind -n C-l send-keys C-l \; run 'sleep 0.2' \; clear-history

      # pane navigation
      bind > swap-pane -D       # swap current pane with the next one
      bind < swap-pane -U       # swap current pane with the previous one

      bind < swap-pane -U       # swap current pane with the previous one

      # split and follow
      bind '"' split-window -v -c "#{pane_current_path}"
      bind  %  split-window -h -c "#{pane_current_path}"

      # window reordering
      bind -r C-H swap-window -d -t -1
      bind -r C-L swap-window -d -t +1
    '';
  };
}
