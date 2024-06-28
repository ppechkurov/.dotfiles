{ pkgs, ... }: {
  programs.awscli.enable = true;
  programs.awscli = {
    credentials.default.credential_process = "${pkgs.pass}/bin/pass aws/cli";
    settings.default = { region = "us-east-2"; };
  };
}

