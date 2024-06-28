{ config, lib, pkgs, ... }: {
  services.swayidle = let
    swaylockExe = lib.getExe config.programs.swaylock.package;
    swaymsgExe = "${pkgs.sway}/bin/swaymsg";
    walpaper =
      "${config.home.homeDirectory}/.config/sway/hackerman-wallpapers.jpg";
  in {
    enable = true;
    timeouts = [
      {
        timeout = 300;
        command =
          "${swaylockExe} --image ${walpaper} --daemonize --ignore-empty-password";
      }
      {
        timeout = 600;
        command = "${swaymsgExe} 'output * dpms off'";
        resumeCommand = "${swaymsgExe} 'output * dpms on'";
      }
    ];
  };
}
