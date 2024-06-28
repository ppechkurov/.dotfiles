{ pkgs, lib, config, ... }:
let
  cfg = config.local.meli;
  ouath2 = pkgs.writeScriptBin "oauth2" (builtins.readFile ./oauth2.py);
in with lib; {
  options.local.meli.enable = mkEnableOption "meli";
  options.local.meli.email = mkOption { type = types.str; };
  options.local.meli.secrets_path = mkOption { type = types.str; };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ meli python3 ouath2 ];
    xdg.configFile.meli = with cfg;
      let
        client_id_cmd = "$(pass ${secrets_path}/client_id)";
        client_secret_cmd = "$(pass ${secrets_path}/client_secret)";
        refresh_token_cmd = "$(pass ${secrets_path}/refresh_token)";
      in {
        enable = true;
        text = ''
          [accounts."gmail"]
          root_mailbox = '[Gmail]'
          format = "imap"
          server_hostname='imap.gmail.com'
          server_username="${email}"
          use_oauth2 = true
          server_password_command = "TOKEN=$(oauth2 --user=${email} --quiet --client_id=${client_id_cmd} --client_secret=${client_secret_cmd} --refresh_token=${refresh_token_cmd}) && oauth2 --user=${email} --generate_oauth2_string --quiet --access_token=$TOKEN"
          server_port = "993"
          listing.index_style = "Conversations"
          identity = "${email}"
          display_name = "Name Name"
          subscribed_mailboxes = ["*" ]
          composing.store_sent_mail = false
          composing.send_mail = { hostname = "smtp.gmail.com", port = 587, auth = { type = "xoauth2", token_command = "...", require_auth = true }, security = { type = "STARTTLS" } }
          [composing]
          send_mail = 'false'
        '';
        target = "meli/config.toml";
      };
  };
}
