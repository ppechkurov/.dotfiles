{
  flake.modules.homeManager.gh = { pkgs, lib, ... }: {
    programs.gh.enable = true;
    programs.gh.gitCredentialHelper.enable = false;

    programs.gh.settings = {
      editor = "nvim";
      git_protocol = "ssh";
    };
  };
}
