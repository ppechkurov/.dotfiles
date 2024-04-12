# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:
let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/master.tar.gz";
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      (import "${home-manager}/nixos")
    ];

  home-manager.users.petrp = {
    gtk = {
      enable = true;
      font = {
        name = "CartographCF Nerd Font";
        size = 12;
      };
    };

    xdg = {
      enable = true;
      configFile.xkb = {
        enable = true;
        source = ./us-prog;
        target = "xkb/symbols/us-prog";
      };
    };

    wayland.windowManager.sway = {
      enable = true;
      systemd.enable = true;
      extraSessionCommands = ''
        export XDG_CURRENT_DESKTOP=sway;
      '';
      wrapperFeatures.gtk = true;
      config = {
        bindkeysToCode = true;
        window = {
          titlebar = false;
          border = 0;
        };
        input = {
          "type:keyboard" = {
            # xkb_file = "/home/petrp/keymap.xkb";
            xkb_layout = "us-prog,ru";
            # xkb_variant = "dvorak,,";
            # xkb_options = "ctrl:nocaps,grp:alt_space_toggle";
            repeat_delay = "200";
            repeat_rate = "30";
          };
          "type:mouse" = {
            dwt = "disabled";
            accel_profile = "flat";
          };
        };
        keybindings = let
          mod = "Mod4";
          concatAttrs = lib.fold (x: y: x // y) { };
          tagBinds = concatAttrs (map (i: {
            "${mod}+${toString i}" = "exec 'swaymsg workspace ${toString i}'";
            "${mod}+Shift+${toString i}" =
              "exec 'swaymsg move container to workspace ${toString i}'";
          }) (lib.range 0 9));
        in tagBinds // {
          "${mod}+o" = "exec ${lib.getExe pkgs.hyprpicker} -a -n";
          "${mod}+0" = "input type:keyboard xkb_switch_layout next";


          "${mod}+Return" = "exec alacritty";
          "${mod}+d" = "exec firefox";

          "${mod}+q" = "kill";
          "${mod}+r" = ''mode "resize"'';
          "${mod}+h" = "focus left";
          "${mod}+j" = "focus down";
          "${mod}+k" = "focus up";
          "${mod}+l" = "focus right";
          "${mod}+Shift+h" = "move left";
          "${mod}+Shift+j" = "move down";
          "${mod}+Shift+k" = "move up";
          "${mod}+Shift+l" = "move right";
          "${mod}+e" = "layout toggle split";
          "${mod}+f" = "fullscreen";
          "${mod}+space" = "floating toggle";
          "${mod}+Shift+s" = "sticky toggle";
          "${mod}+Shift+space" = "focus mode_toggle";
          "${mod}+a" = "focus parent";
          "${mod}+Shift+c" = "reload";
          "${mod}+Shift+q" = "exit";
        };
        bars = [{
          position = "top";
          command = "${lib.getExe pkgs.waybar}";
        }];
        defaultWorkspace = "workspace 1";
      };
    };

    home.stateVersion = "23.11";
  };

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Europe/Minsk";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.petrp = {
    isNormalUser = true;
    initialPassword = "0015";
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [];
  };

  # Hyprland
  programs.sway = {
    enable = true;
  };
  programs.xwayland.enable = true;
  
  services.picom = {
    enable = true;
    settings = {
      animations = true;
    };
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    gnumake
    foot
    git
    wget
    dunst
    libnotify
    alacritty
    kitty
    waybar
  ];

  environment.sessionVariables = {
    MOZ_ENABLE_WAYLAND="1";
    QT_QPA_PLATFORM="wayland";
    XDG_SESSION_TYPE="wayland";
    WLR_NO_HARDWARE_CURSORS = "1";
  };

  hardware = {
    #opengl.enable = true;
    #nvidia.modesetting.enable = true;
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "23.11"; # Did you read the comment?
}

