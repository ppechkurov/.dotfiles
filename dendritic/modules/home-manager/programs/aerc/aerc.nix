{ self, ... }: {
  flake.modules.homeManager.aerc = { pkgs, lib, ... }:
    let
      mkAcc = type:
        { primary ? false, flavor ? "gmail.com", host ? null }:
        let
          cfg = lib.mkIf (host != null) { inherit host; };
          email = self.globals.emails.${type};
        in {
          primary = lib.mkDefault primary;
          address = email;
          aerc.enable = true;
          flavor = flavor;
          folders.inbox = "INBOX";
          imap = cfg;
          passwordCommand = "pass aerc/${email}";
          realName = "Petr Pechkurov";
          smtp = cfg;
          userName = email;
        };
    in {
      programs.aerc.enable = true;

      programs.aerc.extraConfig = {
        general.unsafe-accounts-conf = true;
        ui = {
          this-day-time-format = ''"           15:04"'';
          this-year-time-format = "Mon Jan 02 15:04";
          timestamp-format = "2006-01-02 15:04";

          spinner = "[ ⡿ ],[ ⣟ ],[ ⣯ ],[ ⣷ ],[ ⣾ ],[ ⣽ ],[ ⣻ ],[ ⢿ ]";
        };
        viewer = { always-show-mime = true; };
        compose = { no-attachment-warning = "^[^>]*attach(ed|ment)"; };
        filters = {
          "text/plain" = "colorize";
          "text/html" = "html";
          "text/calendar" = "calendar";
          "message/delivery-status" = "colorize";
          "message/rfc822" = "colorize";
        };
      };

      accounts.email.accounts = {
        Personal = mkAcc "gmail" { };
        Work = mkAcc "work" { };
        Slonverse = mkAcc "slonverse" {
          flavor = "plain";
          host = "mail.slonverse.xyz";
          primary = true;
        };
      };
    };
}
