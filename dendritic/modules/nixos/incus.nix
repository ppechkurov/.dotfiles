{
  flake.modules.nixos.incus = { pkgs, ... }: {
    virtualisation.incus.enable = true;
    networking.nftables.enable = true;

    networking.firewall.interfaces.incusbr0.allowedTCPPorts = [
      53
      67
    ];

    networking.firewall.interfaces.incusbr0.allowedUDPPorts = [
      53
      67
    ];
  };
}
