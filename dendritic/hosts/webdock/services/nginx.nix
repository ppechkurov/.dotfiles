{ self, ... }: {
  flake.modules.nixos.webdock = { config, ... }: {
    security.acme.acceptTerms = true;
    security.acme.defaults.email = self.globals.emails.gmail;

    networking.firewall.allowedTCPPorts = [ 80 443 ];

    services.nginx.enable = true;
    services.nginx.recommendedOptimisation = true;
  };
}
