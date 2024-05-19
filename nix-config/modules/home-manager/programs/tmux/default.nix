{
  programs.tmux.enable = true;
  programs.tmux = {
    baseIndex = 1;
    mouse = true;
    extraConfig = ''
      set -g default-terminal "screen-256color"
      set -g status off
      set -g pane-border-style fg=blue
      set -g pane-active-border-style "bg=default fg=blue"
    '';
  };
}
