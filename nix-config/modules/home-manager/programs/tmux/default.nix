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
      {
        plugin = inputs.minimal-tmux.packages.${pkgs.system}.default;
        extraConfig = ''
          set -g @minimal-tmux-status-right "#[bg=default,fg=default,bold] #h  "
        '';
      }
    ];
    extraConfig = ''
      set -g default-terminal "screen-256color"
      set -g pane-border-style fg=blue
      set -g pane-active-border-style "bg=default fg=blue"

      set -g status "on"

      set -g renumber-windows on    # renumber windows when a window is closed
      set -g set-titles on          # set terminal title

      bind -n C-Enter copy-mode

      bind -n C-k copy-mode \; send -X halfpage-up
      bind -n C-j copy-mode \; send -X halfpage-down

      bind-key -T copy-mode-vi C-k send -X halfpage-up
      bind-key -T copy-mode-vi C-j send -X halfpage-down
      bind-key -T copy-mode-vi v send -X begin-selection
      bind-key -T copy-mode-vi C-v send -X begin-selection \; send-keys -X rectangle-toggle
      bind-key -T copy-mode-vi y send -X copy-selection-and-cancel

      bind-key -T copy-mode-vi ? command-prompt -i -p "search down" "send -X search-forward-incremental \"%%%\""
      bind-key -T copy-mode-vi / command-prompt -i -p "search up" "send -X search-backward-incremental \"%%%\""

      bind -n C-l send-keys C-l \; run 'sleep 0.2' \; clear-history

      # pane navigation
      bind -r h select-pane -L  # move left
      bind -r j select-pane -D  # move down
      bind -r k select-pane -U  # move up
      bind -r l select-pane -R  # move right
      bind > swap-pane -D       # swap current pane with the next one
      bind < swap-pane -U       # swap current pane with the previous one

      # pane resizing
      bind -r H resize-pane -L 2
      bind -r J resize-pane -D 2
      bind -r K resize-pane -U 2
      bind -r L resize-pane -R 2

      # split current window horizontally
      bind - split-window -v

      # split current window vertically
      bind | split-window -h
    '';
  };
}
