{ modulesPath, pkgs, lib, ... }: {
  imports = [ (modulesPath + "/profiles/qemu-guest.nix") ];
  boot.loader.grub = {
    efiSupport = true;
    efiInstallAsRemovable = true;
    device = "nodev";
  };
  boot.initrd.availableKernelModules =
    [ "ata_piix" "uhci_hcd" "xen_blkfront" "vmw_pvscsi" ];
  boot.initrd.kernelModules = [ "nvme" ];
  fileSystems."/" = {
    device = "/dev/sda2";
    fsType = "ext4";
  };
  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/0EFD-C840";
    fsType = "vfat";
  };

  environment.systemPackages = [ pkgs.sshfs ];
  fileSystems."/mnt/sshfs" = {
    device = "petrp@mini.local.wg:/mnt/hdd";
    fsType = "sshfs";
    options = [
      "_netdev" # this is a network fs
      "allow_other" # for non-root access
      "nofail"
      "x-systemd.automount" # mount on demand

      # SSH options
      "reconnect" # handle connection drops
      "ServerAliveInterval=15" # keep connections alive
      "IdentityFile=/home/petrp/.ssh/id_ed25519"
    ];
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
