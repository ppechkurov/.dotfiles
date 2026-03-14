{
  flake.modules.nixos.kirillp = { pkgs, ... }: {
    networking.networkmanager.enable = true;

    networking.hosts = {
      "192.168.100.9" = [ "home.lan" ];
      "192.168.100.14" = [ "mini.lan" ];
      "192.168.100.20" = [ "kirill.lan" ];
    };

    environment.systemPackages = with pkgs; [ wakeonlan ];
    networking.interfaces.enp1s0.wakeOnLan = {
      enable = true;
      policy = [ "magic" ];
    };
  };
}
