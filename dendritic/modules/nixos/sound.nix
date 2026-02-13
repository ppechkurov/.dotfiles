{
  flake.modules.nixos.sound = { pkgs, ... }: {
    services.pipewire.enable = true;
    services.pipewire.pulse.enable = true;
    services.pipewire.alsa.enable = true;
    services.pipewire.alsa.support32Bit = true;

    security.rtkit.enable = true;
    # security.polkit.enable = true;
  };
}
