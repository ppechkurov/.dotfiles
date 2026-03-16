{
  flake.modules.homeManager.passff = { lib, pkgs, ... }: {
    # [see](https://codeberg.org/PassFF/passff-host#preferences)
    programs.firefox = {
      package = lib.mkDefault (pkgs.firefox.override {
        nativeMessagingHosts = [
          (pkgs.passff-host.overrideAttrs (old: {
            dontStrip = true;
            patchPhase = ''
              sed -i 's#COMMAND = "pass"#COMMAND = "${
                pkgs.pass-wayland.withExtensions (ext: with ext; [ pass-otp ])
              }/bin/pass"#' src/passff.py
            '';
          }))
        ];
      });
    };
  };
}
