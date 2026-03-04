{
  flake.nixos.modules.mini = {
    services.openssh.enable = true;
    services.openssh.allowSFTP = true;
    services.openssh.settings.PasswordAuthentication = false;
  };
}
