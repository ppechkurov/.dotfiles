{ pkgs, ... }: {
  programs.awscli.enable = true;
  programs.awscli = {
    settings.default = { region = "us-east-2"; };
    credentials.default.credential_process =
      "${pkgs.pass}/bin/pass aws/cli/default";

    credentials.cargill.credential_process =
      "${pkgs.pass}/bin/pass aws/cli/cargill";
  };
}

