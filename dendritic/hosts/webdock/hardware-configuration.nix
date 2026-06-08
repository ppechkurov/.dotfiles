{
  flake.modules.nixos.webdock = { pkgs, lib, modulesPath, ... }: {
    imports = [ (modulesPath + "/profiles/qemu-guest.nix") ];
    boot.kernelPackages = pkgs.linuxPackages_6_12;
    boot.loader.grub = {
      efiSupport = true;
      efiInstallAsRemovable = true;
      device = "nodev";
    };
    boot.initrd.availableKernelModules =
      [ "ata_piix" "uhci_hcd" "xen_blkfront" "vmw_pvscsi" ];
    boot.initrd.kernelModules = [ "nvme" ];
    fileSystems."/" = {
      device = "/dev/disk/by-uuid/26df4d07-a74f-4229-8b2d-0b8f1d87e940";
      fsType = "ext4";
    };
    fileSystems."/boot" = {
      device = "/dev/disk/by-uuid/0EFD-C840";
      fsType = "vfat";
    };

    environment.systemPackages = [ pkgs.sshfs ];
    fileSystems."/mnt/sshfs" = {
      device = "petrp@mini.wg:/mnt/hdd";
      fsType = "sshfs";
      options = [
        "_netdev" # this is a network fs
        "allow_other" # for non-root access
        "nofail"
        "noatime"

        "x-systemd.automount" # mount on demand

        # SSH options
        "reconnect" # handle connection drops
        "ConnectTimeout=5" # fail fast if mini unreachable
        "ServerAliveInterval=15" # keep connections alive
        "IdentityFile=/home/petrp/.ssh/id_ed25519"
      ];
    };

    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  };
}
