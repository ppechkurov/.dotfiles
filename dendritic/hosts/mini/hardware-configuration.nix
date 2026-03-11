{
  flake.modules.nixos.mini = { config, lib, modulesPath, ... }: {
    imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

    boot.initrd.availableKernelModules =
      [ "xhci_pci" "ahci" "nvme" "usb_storage" "sd_mod" ];
    boot.initrd.kernelModules = [ "nvme" ];
    boot.kernelModules = [ ];
    boot.extraModulePackages = [ ];

    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    fileSystems."/" = {
      device = "/dev/disk/by-label/nixos";
      fsType = "ext4";
    };

    fileSystems."/mnt/hdd" = {
      device = "/dev/disk/by-label/hdd";
      options = [ "nofail" "noatime" "nodiratime" ];
    };

    fileSystems."/mnt/backup" = {
      device = "/dev/disk/by-label/backup";
      options = [ "nofail" "noatime" "nodiratime" ];
    };

    fileSystems."/boot" = {
      device = "/dev/disk/by-label/boot";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };

    swapDevices = [{ device = "/dev/disk/by-label/swap"; }];

    networking.useDHCP = lib.mkDefault true;

    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
    hardware.cpu.intel.updateMicrocode =
      lib.mkDefault config.hardware.enableRedistributableFirmware;
  };
}
