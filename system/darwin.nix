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
      (import ./overlays/aws-sam-cli.nix)
      (import ./overlays/former.nix)
      (import ./overlays/aws-whoami.nix)
    ];
  };
  defaultConfiguration =
    { pkgs, config, ... }:
    {
      # nix-darwin version
      system.stateVersion = 6;
      # nix configuration
      # nix.settings.sandbox = true;
      nix.enable = true;
      nix.package = pkgs.nix;
      nix.checkConfig = true;
      nix.nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];
      nix.gc = {
        automatic = true;
        interval = [
          {
            Hour = 0;
          }
        ];
      };
      nix.optimise = {
        automatic = true;
        interval = [
          {
            Hour = 0;
          }
        ];
      };
      nix.settings = {
        experimental-features = "nix-command flakes";
        substituters = [
          "https://nix.barney.dev/"
          "https://cache.nixos.org/"
        ];
        trusted-public-keys = [
          "nix.barney.dev-1:Wz6Nj2M/3PogEKI4/SRIdUm83QlC6zZN/0CCTS9oJ2o="
          "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        ];
        trusted-users = [
          "root"
          "${username}"
        ];
      };
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
    ./sketchybar
    ./fonts
    inputs.nix-homebrew.darwinModules.nix-homebrew
    inputs.home-manager.darwinModules.home-manager
    homeManagerConfig
  ];
}
