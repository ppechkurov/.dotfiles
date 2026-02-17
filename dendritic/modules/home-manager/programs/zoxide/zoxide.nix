{
  flake.modules.homeManager.zoxide = {
    programs.zoxide.enable = true;

    programs.zoxide = {
      enableZshIntegration = true;
      options = [ "--cmd" "cd" ];
    };
  };
}
