{
  username,
  inputs,
}:

{ system }:

let
  pkgs = import inputs.nixpkgs {
    inherit system;
    config = {
      allowUnfree = true;
    };
  };
  unstable = import inputs.nixpkgs-unstable {
    inherit system;
    config = {
      allowUnfree = true;
    };
  };
  defaultConfiguration =
    { pkgs, config, ... }:
    {
      # nix-darwin version
      system.stateVersion = 5;
      # nix configuration
      services.nix-daemon.enable = true;
      nix.package = pkgs.nix;
      nix.settings.experimental-features = "nix-command flakes";
      nixpkgs.config = {
        allowUnfree = true;
      };
      # default user setting
      users.users.${username}.home = "/Users/${username}";
    };
in
inputs.nix-darwin.lib.darwinSystem {
  inherit system inputs pkgs;
  specialArgs = {
    inherit
      system
      username
      unstable
      ;
  };
  modules = [
    defaultConfiguration
    ./darwin-settings
    ./homebrew
    ./aerospace
    ./fonts
    inputs.nix-homebrew.darwinModules.nix-homebrew
    inputs.home-manager.darwinModules.home-manager
    ../home
  ];
}
