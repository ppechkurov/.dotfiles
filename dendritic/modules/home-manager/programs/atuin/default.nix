{ self, ... }: {
  flake.modules.homeManager.atuin = { osConfig, ... }:
    let
      ip = self.globals.wg.servers.networks.tun.ipv4;
      port = toString osConfig.services.atuin.port;
    in {
      programs.atuin.enable = true;

      programs.atuin = {
        enableZshIntegration = true;
        flags = [ "--disable-up-arrow" ];
        settings = {
          enter_accept = true;
          filter_mode = "host";
          inline_height = 30;
          invert = true;
          keymap_mode = "vim-insert";
          keys = { scroll_exits = false; };
          max_preview_height = 10;
          show_preview = true;
          style = "full";
          sync_address = "http://${ip}:${port}";
          update_check = false;
        };
      };
    };
}
