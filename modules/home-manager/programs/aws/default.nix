{ pkgs, ... }:
let
  abl = pkgs.writeShellScriptBin "abl"
    (builtins.readFile ./scripts/aws_jobs_logs.sh);
in {
  home.packages = [ abl ];

  programs.awscli = {
    enable = true;
    # settings.default = { region = "us-east-2"; };
    # settings.futudo = { region = "eu-central-1"; };
    #
    # credentials.default.credential_process =
    #   "${pkgs.pass}/bin/pass aws/cli/default";
    #
    # credentials.futudo.credential_process =
    #   "${pkgs.pass}/bin/pass aws/cli/futudo";
  };
}

