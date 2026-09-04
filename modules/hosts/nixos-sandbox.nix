{ config, inputs, ... }:
let
  inherit (config.flake.modules) nixos homeManager;
in
{
  flake.packages.aarch64-darwin.nixos-sandbox-image =
    config.flake.nixosConfigurations.nixos-sandbox.config.system.build.images.qemu-efi;

  flake.nixosConfigurations.nixos-sandbox = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      ({ modulesPath, ... }: { imports = [ "${modulesPath}/profiles/qemu-guest.nix" ]; })

      nixos.overlays
      nixos.nix-settings
      nixos.user
      nixos.hyprland
      nixos.utm-vm

      inputs.home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.users.${config.user.name} = {
          imports = [
            homeManager.user
            homeManager.packages
            homeManager.zsh
            homeManager.direnv
            homeManager.git
            homeManager.tmux
            homeManager.ghostty
            homeManager.hyprland
            homeManager.quickshell
            homeManager.awsume
            homeManager.awsuse
            homeManager.agents
            homeManager.ssh
            homeManager.npm
          ];
        };
      }
    ];
  };
}
