# Nixos Configuration

## Overview

This documentation provides an overview of the NixOS configuration setup, including flake configuration, system configuration, user configuration, and Home Manager integration.

## `flake.nix`

### Description

The `flake.nix` file serves as the main entry point for the NixOS configuration flake.

### Inputs

- `nixpkgs`: Nixpkgs repository for NixOS unstable.
- `home-manager`: Integration of Home Manager for user-specific configurations.
- `hyprland`: Package necessary for the Window Manager configuration.

### Outputs

- `nixosConfigurations`: Defines system configurations.

## `configuration.nix` (hosts/\*)

### System Configuration

- Bootloader, Filesystems, Networking, Time Zone, Internationalization, Services, Programs, Security, Fonts, User Account.

### Home Manager Integration

- Manages user-specific configurations.

## `home.nix` (hosts/\*)

### User Configuration

- Sets username, home directory, and additional packages.
- Defines session variables and enables Home Manager.

## `hardware-configuration.nix`

- Automatically generated file containing hardware configuration.

## Hosts (hosts/\*)

- hosts/home - home pc
- hosts/work - work pc

## Modules (modules/\*)

- All modules for NixOS or Home Manager

## Instructions for Replication

1. **Clone the Repository**: Clone your NixOS configuration repository to your local machine.

   ```bash
   git clone https://github.com/ppechkurov/.dotfiles.git
   ```

2. **Build and Activate Configuration**: Run the following command to build and activate your NixOS configuration.

   ```bash
   sudo nixos-rebuild switch --flake .#<host-name>
   ```
