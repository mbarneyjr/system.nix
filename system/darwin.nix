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
    overlays = [
      (import ./overlays/awscurl.nix)
      (import ./overlays/cfn-transform.nix)
      (import ./overlays/former.nix)
      (import ./overlays/aws-whoami.nix)
    ];
  };
  defaultConfiguration =
    { pkgs, config, ... }:
    {
      # nix-darwin version
      system.stateVersion = 5;
      # nix configuration
      services.nix-daemon.enable = true;
      nix.package = pkgs.nix;
      nix.nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];
      nix.settings.experimental-features = "nix-command flakes";
      nixpkgs.config = {
        allowUnfree = true;
      };
      # default user setting
      users.users.${username}.home = "/Users/${username}";
    };
  homeManagerConfig =
    {
      pkgs,
      config,
      inputs,
      system,
      username,
      unstable,
      ...
    }:
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.extraSpecialArgs = {
        glimpse = inputs.glimpse.packages.${system}.default;
        mbnvim = inputs.mbnvim.packages.${system}.default;
        inherit unstable;
      };
      home-manager.users.${username} = import ../home { inherit pkgs username; };
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
    homeManagerConfig
  ];
}
