{
  flake.modules.nixos.steam = { pkgs, ... }: {
    programs.steam.enable = true;
    programs.steam.gamescopeSession.enable = true;
    programs.gamemode.enable = true;

    environment.sessionVariables = {
      STEAM_EXTRA_COMPAT_TOOLS_PATHS =
        "\${HOME}/.steam/root/compatibilitytools.d";
    };

    environment.systemPackages = with pkgs; [ protonup-ng ];
  };
}
