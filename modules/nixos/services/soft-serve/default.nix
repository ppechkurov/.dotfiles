{ pkgs-unstable, ... }: {
  networking.firewall.allowedTCPPorts = [
    23231 # git ssh
    23232 # git http
    23233 # stats
  ];

  services.soft-serve.package = pkgs-unstable.soft-serve;
  services.soft-serve.settings = {
    name = "Soft Serve";
    log_format = "text";
    ssh = {
      listen_addr = ":23231";
      public_url = "ssh://192.168.100.14:23231";
      max_timeout = 0;
      idle_timeout = 120;
    };
    stats.listen_addr = ":23233";
    initial_admin_keys = [
      "'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM/8sFXfWRrIE+n4TtvawXjd1QKIYadM2OR9PGOxHKrP petrp@home'"
    ];
  };
}
