{ config, inputs, ... }:
let
  inherit (config.flake.modules) darwin homeManager;
in
{
  configurations.darwin = {
    aarch64.module = {
      imports = [
        darwin.overlays
        darwin.nix-settings
        darwin.darwin-settings
        darwin.homebrew
        darwin.aerospace
        darwin.sketchybar
        darwin.fonts
        darwin.user

        inputs.home-manager.darwinModules.home-manager
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
              homeManager.awsume
              homeManager.awsuse
              homeManager.claude
              homeManager.ssh
            ];
          };
        }
      ];
      nixpkgs.hostPlatform = "aarch64-darwin";
    };
  };
}
