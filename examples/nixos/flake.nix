# NixOS Flake Configuration
#
# This flake is machine-agnostic. Hardware configuration comes from
# /etc/nixos/hardware-configuration.nix on each target machine.
#
# Usage:
#   1. Boot NixOS installer
#   2. Partition disks and mount at /mnt
#   3. Run: nixos-generate-config --root /mnt
#   4. Clone this repo
#   5. Run: sudo nixos-install --flake /path/to/repo#default
#   6. Reboot, then: sudo nixos-rebuild switch --flake /path/to/repo#default

{
  description = "NixOS configuration";

  inputs = {
    # Nixpkgs - use unstable for latest packages (or nixos-24.11 for stable)
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Home Manager - manage user dotfiles and packages
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Optional: Hardware quirks for specific laptops/hardware
    # nixos-hardware.url = "github:NixOS/nixos-hardware";

    # Declarative disk partitioning
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, disko, ... }@inputs:
    let
      # Helper function to create a NixOS system
      mkSystem = { system ? "x86_64-linux", extraModules ? [] }:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };  # Pass inputs to modules
          modules = [
            ./configuration.nix

            # Disko for declarative disk management
            disko.nixosModules.disko
            ./disk-config.nix

            # Home Manager as a NixOS module
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;      # Use system nixpkgs
                useUserPackages = true;    # Install to /etc/profiles
                extraSpecialArgs = { inherit inputs; };

                users.mbarney = import ./home.nix;
              };
            }
          ] ++ extraModules;
        };
    in
    {
      # Default configuration - works on any x86_64 machine
      nixosConfigurations = {
        # Generic x86_64 system
        default = mkSystem {
          system = "x86_64-linux";
        };

        # Generic aarch64 system (ARM64, e.g., Raspberry Pi, Ampere)
        default-aarch64 = mkSystem {
          system = "aarch64-linux";
        };

        # Example: Named host with extra modules
        # my-laptop = mkSystem {
        #   system = "x86_64-linux";
        #   extraModules = [
        #     # inputs.nixos-hardware.nixosModules.lenovo-thinkpad-x1-carbon
        #     ./hosts/my-laptop.nix  # Host-specific overrides
        #   ];
        # };
      };

      # Expose overlays if you have custom packages
      # overlays.default = import ./overlays;
    };
}
