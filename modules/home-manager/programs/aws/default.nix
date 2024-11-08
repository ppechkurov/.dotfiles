{ pkgs, ... }:
let
  abl = pkgs.writeShellScriptBin "abl"
    (builtins.readFile ./scripts/aws_jobs_logs.sh);
in {
  home.packages = [ abl ];

  programs.awscli = {
    enable = true;
    settings.default = { region = "us-east-2"; };

    credentials.default.credential_process =
      "${pkgs.pass}/bin/pass aws/cli/default";

    credentials.cargill.credential_process =
      "${pkgs.pass}/bin/pass aws/cli/cargill";
  };
}

