{
  flake.modules.homeManager.gpg = { pkgs, ... }: {
    programs.gpg.enable = true;

    services.gpg-agent.enable = true;
    services.gpg-agent.enableZshIntegration = true;
    services.gpg-agent.enableSshSupport = true;

    services.gpg-agent.pinentry.package =
      pkgs.writeShellScriptBin "pinentry-wrapper" ''
        if [[ -z $DISPLAY ]]; then
          exec ${pkgs.pinentry-curses}/bin/pinentry "$@"
        else
          exec ${pkgs.pinentry-gnome3}/bin/pinentry "$@"
        fi
      '';
  };
}
