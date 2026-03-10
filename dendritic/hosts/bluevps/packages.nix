{ inputs, ... }: {
  flake.modules.nixos.mini = { pkgs, pkgs-unstable, ... }: {
    environment.systemPackages = with pkgs; [
      git
      sshfs
      lm_sensors
      inetutils
      #
    ];
  };
}
