{
  flake.modules.nixos.pass = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      oath-toolkit
      (pass-wayland.withExtensions (exts: [ exts.pass-otp exts.pass-tomb ]))
    ];
  };
}
