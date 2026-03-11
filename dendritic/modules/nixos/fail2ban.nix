{
  flake.modules.nixos.fail2ban = {
    services.fail2ban.enable = true;
    services.fail2ban.bantime-increment = {
      enable = true;
      factor = "4";
      maxtime = "48h";
    };
  };
}
