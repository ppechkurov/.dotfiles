{
  flake.modules.nixos.home = { config, lib, pkgs, modulesPath, ... }: {
    imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

    boot.initrd.availableKernelModules =
      [ "xhci_pci" "ehci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" ];
    boot.kernelModules = [ "kvm-intel" "btusb" ];
    boot.kernelPackages = pkgs.linuxPackages_6_6; # the kernel

    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
    # Fix artifacts on boot: [link](https://github.com/NixOS/nixpkgs/issues/328972#issuecomment-3665270723)
    boot.loader.systemd-boot.consoleMode = "auto";

    fileSystems."/" = {
      device = "/dev/disk/by-label/big";
      fsType = "ext4";
    };

    fileSystems."/boot" = {
      device = "/dev/disk/by-label/bootb";
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
    };

    swapDevices = [{ device = "/dev/disk/by-label/swapb"; }];

    networking.useDHCP = lib.mkDefault true;

    hardware.enableAllFirmware = true;
    hardware.cpu.intel.updateMicrocode =
      lib.mkDefault config.hardware.enableRedistributableFirmware;
  };
}
