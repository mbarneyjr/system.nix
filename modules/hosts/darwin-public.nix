{ config, inputs, ... }:
let
  inherit (config.flake.modules) darwin homeManager;
in
{
  configurations.darwin = {
    aarch64-public.module = {
      imports = [
        darwin.overlays
        darwin.nix-settings
        darwin.darwin-settings
        darwin.homebrew
        darwin.aerospace
        darwin.sketchybar
        darwin.fonts
        darwin.user
        darwin.agents

        inputs.home-manager.darwinModules.home-manager
        {
          services.sketchybar.enable = false;
          proprietary.berkeleyMono.enable = false;
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
              homeManager.awsume
              homeManager.awsuse
              homeManager.agents
              homeManager.ssh
            ];
          };
        }
      ];
      nixpkgs.hostPlatform = "aarch64-darwin";
    };
  };
}
