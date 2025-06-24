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
    overlays = [
      (import ./overlays/awscurl.nix)
      (import ./overlays/cfn-transform.nix)
      (import ./overlays/former.nix)
      (import ./overlays/aws-whoami.nix)
      (import ./overlays/amazon-q.nix)
    ];
  };
  defaultConfiguration =
    { pkgs, config, ... }:
    {
      # nix-darwin version
      system.stateVersion = 6;
      # nix configuration
      nix.enable = true;
      nix.package = pkgs.nix;
      nix.nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];
      nix.settings.experimental-features = "nix-command flakes";
      nixpkgs.config = {
        allowUnfree = true;
      };
      # default user setting
      system.primaryUser = username;
      users.users.${username} = {
        home = "/Users/${username}";
        shell = pkgs.zsh;
      };
    };
  homeManagerConfig =
    {
      pkgs,
      config,
      inputs,
      system,
      username,
      ...
    }:
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.extraSpecialArgs = {
        glimpse = inputs.glimpse.packages.${system}.default;
        mbnvim = inputs.mbnvim.packages.${system}.default;
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
