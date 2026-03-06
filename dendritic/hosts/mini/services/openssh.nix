{ self, ... }: {
  flake.nixos.modules.mini = {
    services.openssh.enable = true;
    services.openssh.allowSFTP = true;
    services.openssh.settings.PasswordAuthentication = false;

    # For deployment
    users.users.root.openssh.authorizedKeys.keys =
      self.globals.publicKeys.users.petrp;
  };
}
