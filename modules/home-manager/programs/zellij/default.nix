{ config, lib, ... }: {
  options.local.zellij.enable = lib.mkEnableOption "zellij";

  config = lib.mkIf config.local.zellij.enable {
    programs.zellij.enable = true;

    xdg.configFile."zellij/layouts/default.kdl" = {
      enable = true;
      recursive = true;
      text = ''
        layout {
            cwd "$HOME/projects/backup"

            tab name="server & client" focus=true {
                pane size=1 borderless=true {
                    plugin location="zellij:tab-bar"
                }

                pane name="server" focus=true {
                    command "npm"
                    args "run" "dev:server"
                }

                pane name="client" size=6 {
                    command "npm"
                    args "run" "dev:client"
                }

                pane size=2 borderless=true {
                    plugin location="zellij:status-bar"
                }
            }

            tab name="master & security" {
                pane size=1 borderless=true {
                    plugin location="zellij:tab-bar"
                }

                pane name="master" {
                    command "npm"
                    args "run" "dev:master"
                }

                pane name="security" {
                    command "npm"
                    args "run" "dev:security"
                }

                pane size=2 borderless=true {
                    plugin location="zellij:status-bar"
                }
            }
        }
      '';
    };
  };
}
