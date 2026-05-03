{
  flake.modules.homeManager.sesh = { pkgs-unstable, lib, ... }: {
    programs.sesh.enable = true;
    programs.sesh.package = pkgs-unstable.sesh;
    programs.sesh = {
      settings = builtins.fromTOML (builtins.readFile ./sesh.toml);
    };

    programs.fzf.tmux.enableShellIntegration = true;

    # this binds prefix+s to a default sesh
    programs.sesh.enableTmuxIntegration = true;

    programs.zsh.initContent = # bash
      ''
        source <(sesh completion zsh)
        function sesh-sessions() {
          {
            exec </dev/tty
            exec <&1
            local session
            session=$(
              sesh list --icons |
                fzf-tmux -p 80%,70% \
                  --no-sort --ansi --border-label ' sesh ' --prompt '⚡  ' \
                  --header '  ^a all ^t tmux ^g configs ^x tmux kill' \
                  --bind 'tab:down,btab:up' \
                  --bind 'ctrl-a:change-prompt(⚡  )+reload(sesh list --icons)' \
                  --bind 'ctrl-g:change-prompt(⚙️  )+reload(sesh list -c --icons)' \
                  --bind 'ctrl-t:change-prompt(🪟  )+reload(sesh list -t --icons)' \
                  --bind 'ctrl-x:execute(tmux kill-session -t {2..})+change-prompt(⚡  )+reload(sesh list --icons)' \
                  --bind 'ctrl-u:preview-half-page-up' \
                  --bind 'ctrl-d:preview-half-page-down' \
                  --preview-window 'right:55%' \
                  --preview 'sesh preview {}'
            )
            zle reset-prompt >/dev/null 2>&1 || true
            [[ -z "$session" ]] && return
            sesh connect $session
          }
        }
      '';
  };
}
