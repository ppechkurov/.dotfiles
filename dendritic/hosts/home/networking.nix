{
  flake.modules.nixos.home = {
    networking.hosts = {
      "192.168.100.9" = [ "home.lan" ];
      "192.168.100.14" = [ "mini.lan" ];
      "192.168.100.20" = [ "kirill.lan" ];
    };

    networking.interfaces.enp5s0.wakeOnLan = {
      enable = true;
      policy = [ "magic" ];
    };
  };
}
