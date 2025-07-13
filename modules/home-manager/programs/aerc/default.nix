{ pkgs, ... }: {
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

  services.imapnotify.enable = true;

  accounts.email.accounts.Work = {
    address = "petr.pechkurov@succraft.com";
    aerc.enable = true;
    flavor = "gmail.com";
    folders.inbox = "INBOX";
    passwordCommand = "pass success/gmail/aerc";
    primary = true;
    realName = "Petr Pechkurov";
    userName = "petr.pechkurov@succraft.com";
  };

  accounts.email.accounts.Slonverse = {
    address = "petr.pechkurov@slonverse.xyz";
    aerc.enable = true;
    flavor = "plain";
    folders.inbox = "INBOX";
    imap = { host = "mail.slonverse.xyz"; };
    smtp = { host = "mail.slonverse.xyz"; };
    imapnotify.enable = true;
    imapnotify.boxes = [ "INBOX" ];
    imapnotify.onNotifyPost =
      "${pkgs.libnotify}/bin/notify-send 'New mail arrived'";
    passwordCommand = "pass mail/petr.pechkurov@slonverse.xyz";
    realName = "Petr Pechkurov";
    userName = "petr.pechkurov@slonverse.xyz";
  };
}

