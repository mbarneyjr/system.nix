{ config, ... }:
let
  inherit (config.flake.modules) homeManager;

  commonHomeModule = {
    imports = [
      homeManager.user
      homeManager.overlays
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
      homeManager.npm
    ];
  };
in
{
  configurations.homeManager = {
    aarch64 = {
      system = "aarch64-linux";
      module = {
        imports = [ commonHomeModule ];
      };
    };
    x86_64 = {
      system = "x86_64-linux";
      module = {
        imports = [ commonHomeModule ];
      };
    };
  };
}
