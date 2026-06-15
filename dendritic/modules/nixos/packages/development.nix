{ inputs, self, ... }: {
  flake.modules.nixos.development = { lib, pkgs, pkgs-unstable, ... }:
    let
      libnotify = "${pkgs.libnotify}/bin/notify-send";
      sound =
        "${pkgs.sound-theme-freedesktop}/share/sounds/freedesktop/stereo/complete.oga";

      codex-notify-watch = pkgs.writeShellApplication {
        name = "codex-notify-watch";
        runtimeInputs = [ pkgs.libnotify ];
        text = ''
          set -eu

          queue_file=''${CODEX_NOTIFY_FILE:-/tmp/codex-notify}

          if ! command -v ${libnotify} >/dev/null 2>&1; then
            echo "notify-send was not found" >&2
            exit 127
          fi

          sanitize_text() {
            printf '%s' "$1" | LC_ALL=C tr -d '\001-\010\013\014\016-\037\177'
          }

          play_sound() {
            [ "''${CODEX_NOTIFY_SOUND:-1}" != "0" ] || return 0
            command -v pw-play >/dev/null 2>&1 || return 0
            [ -r ${sound} ] || return 0
            pw-play ${sound} >/dev/null 2>&1 &
          }

          touch "$queue_file"

          tail -n 0 -F "$queue_file" | while IFS='	' read -r title body urgency; do
            [ -n "$title$body" ] || continue
            title=$(sanitize_text "''${title:-Codex}")
            body=$(sanitize_text "''${body:-Done}")

            case "''${urgency:-normal}" in
            critical)
              color='\033[31m'
              urgency='critical'
              ;;
            low)
              color='\033[2m'
              urgency='low'
              ;;
            *)
              color='\033[32m'
              urgency='normal'
              ;;
            esac

            reset='\033[0m'
            timestamp=$(date '+%H:%M:%S')

            printf '%b[%s] %s%b %s\n' "$color" "$timestamp" "$title" "$reset" "$body"
            ${libnotify} --urgency="$urgency" -- "$title" "$body"
            play_sound
          done
        '';
      };

      codex-notify-send = pkgs.writeShellApplication {
        name = "codex-notify-send";
        text = ''
          set -eu

          event=''${1:-stop}
          project_name=''${CODEX_NOTIFY_PROJECT:-$(basename "$PWD")}
          queue_file=''${CODEX_NOTIFY_FILE:-/tmp/codex-notify}
          branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || printf 'unknown')

          case "$event" in
            permission)
              title="Codex approval"
              body="$project_name is waiting for approval on $branch"
              urgency="critical"
              ;;
            *)
              title="Codex"
              body="$project_name turn finished on $branch"
              urgency="normal"
              ;;
          esac

          title=$(printf '%s' "$title" | tr '\t\n' '  ')
          body=$(printf '%s' "$body" | tr '\t\n' '  ')
          urgency=$(printf '%s' "$urgency" | tr '\t\n' '  ')

          printf '%s\t%s\t%s\n' "$title" "$body" "$urgency" >> "$queue_file"
        '';
      };

      hmModule = inputs.home-manager.nixosModules.home-manager;
      hmUserModules = with self.modules.homeManager; [
        atuin
        aws
        fzf
        gh
        git
        gpg
        nodejs
        yazi
        zoxide
        zsh
      ];
    in {
      systemd.tmpfiles.rules = [ "f+ /tmp/codex-notify 0644 petrp users - -" ];

      home-manager.users.petrp.systemd.user.services.codex-notify-watch = {
        Unit.Description = "Codex notification watcher";
        Service.ExecStart = "${codex-notify-watch}/bin/codex-notify-watch";
        Service.Restart = "on-failure";
        Service.Environment = "CODEX_NOTIFY_FILE=/tmp/codex-notify";
        Install.WantedBy = [ "default.target" ];
      };

      # ══ CONTAINER ══
      containers.development = {
        ephemeral = false;
        autoStart = true;
        nixpkgs = "${inputs.nixpkgs-unstable}";

        bindMounts = {
          "/run/docker.sock" = {
            hostPath = "/run/user/1000/docker.sock";
            isReadOnly = false;
          };
          "/home/petrp/projects" = {
            hostPath = "/home/petrp/projects";
            isReadOnly = false;
          };
          "/home/petrp/.dotfiles" = {
            hostPath = "/home/petrp/.dotfiles";
            isReadOnly = true;
          };
          "/home/petrp/.claude" = {
            hostPath = "/home/petrp/.claude";
            isReadOnly = false;
          };
          "/home/petrp/.codex" = {
            hostPath = "/home/petrp/.codex";
            isReadOnly = false;
          };
          "/home/petrp/.npmrc" = {
            hostPath = "/home/petrp/.npmrc";
            isReadOnly = true;
          };
          "/tmp/codex-notify" = {
            hostPath = "/tmp/codex-notify";
            isReadOnly = false;
          };
        };

        config = { config, pkgs, ... }: {
          imports = [ hmModule ];

          nixpkgs.config.allowUnfreePredicate = pkg:
            builtins.elem (lib.getName pkg) [ "claude-code" "codex" ];

          home-manager = {
            useUserPackages = true;
            useGlobalPkgs = true;
            backupFileExtension = "backup";
            users.petrp = {
              imports = hmUserModules;
              _module.args = { inherit pkgs-unstable; };
              home.stateVersion = "24.05";
            };
          };

          users.users.petrp = {
            isNormalUser = true;
            shell = pkgs.zsh;
            home = "/home/petrp";
            description = "Petr Pechkurov";
            group = "users";
          };

          services.gnome.gnome-keyring.enable = true;
          security.pam.services.login.enableGnomeKeyring = true;

          environment.sessionVariables = {
            DOCKER_HOST = "unix:///run/docker.sock";
            DBUS_SESSION_BUS_ADDRESS = "unix:path=/run/user/1000/bus";
            CODEX_NOTIFY_FILE = "/tmp/codex-notify";
          };

          systemd.tmpfiles.rules = [
            "d /run/user/1000 0755 petrp users -"
            "f+ /home/petrp/.docker/config.json 0644 petrp users - {}"
          ];

          programs.zsh.enable = true;

          environment.systemPackages = with pkgs; [
            codex-notify-send
            direnv
            jq
            docker
            gh
            git
            nodejs_24
            claude-code
            codex
            vim
          ];

          system.stateVersion = "25.11";
        };
      };
    };
}
