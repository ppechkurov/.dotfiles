{ config, pkgs, ... }: {
  services.forgejo.enable = true;

  environment.systemPackages = [ pkgs.forgejo ];
  environment.variables = {
    FORGEJO_WORK_DIR = "${config.services.forgejo.stateDir}";
  };

  services.forgejo = {
    package = pkgs.forgejo;
    dump.enable = true;
    settings = {
      service.DISABLE_REGISTRATION = true;
      openid.ENABLE_OPENID_SIGNIN = false;
      server = { ROOT_URL = "https://vps-pp.duckdns.org"; };
    };
  };
}

