{ pkgs-unstable, ... }: {
  programs.go.enable = true;
  programs.go.package = pkgs-unstable.go_1_23;
}

