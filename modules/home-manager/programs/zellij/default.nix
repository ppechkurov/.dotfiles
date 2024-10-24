{ config, lib, ... }: {
  options.local.zellij.enable = lib.mkEnableOption "zellij";

  config = lib.mkIf config.local.zellij.enable {
    programs.zellij.enable = true;

    xdg.configFile."zellij/layouts/backup-v3.kdl" = {
      enable = true;
      recursive = true;
      text = ''
        layout {
          cwd "$HOME/projects/backup-dev"

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
                    cwd "./client"
                    command "npm"
                    args "run" "dev"
                }

                pane size=2 borderless=true {
                    plugin location="zellij:status-bar"
                }
            }

            tab name="database & security & schedulers" {
                pane size=1 borderless=true {
                    plugin location="zellij:tab-bar"
                }

                pane name="database-manager" {
                    command "npm"
                    args "run" "dev:database-manager"
                }

                pane name="security" {
                    command "npm"
                    args "run" "dev:security"
                }

                pane name="schedulers" {
                    command "npm"
                    args "run" "dev:schedulers-manager"
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
