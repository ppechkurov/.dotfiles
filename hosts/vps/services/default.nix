{
  imports = [
    ./nginx.nix
    ./forgejo.nix
    ../../../modules/nixos/wireguard
    #./mailserver.nix
  ];
}
