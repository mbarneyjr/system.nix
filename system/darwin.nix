inputs@{
  nix-darwin,
  home-manager,
  nixpkgs-unstable,
  nix-homebrew,
  homebrew-core,
  homebrew-cask,
  mbnvim,
  glimpse,
  username,
}:

{ system }:

let
  unstable = import nixpkgs-unstable {
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
  darwinSettings = import ./darwin-settings;
  homebrew = import ./homebrew;
  aerospace = import ./aerospace;
  fonts = import ./fonts;
  home-config = import ../home/darwin.nix;
in
nix-darwin.lib.darwinSystem {
  system = system;
  specialArgs = {
    inputs = inputs;
    system = system;
    unstable = unstable;
  };
  modules = [
    defaultConfiguration
    darwinSettings
    nix-homebrew.darwinModules.nix-homebrew
    homebrew
    aerospace
    fonts
    home-manager.darwinModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.extraSpecialArgs = {
        glimpse = glimpse.packages.${system}.default;
        mbnvim = mbnvim.packages.${system}.default;
        inherit unstable;
      };
      home-manager.users.${username}.imports = [
        home-config
      ];
    }
  ];
}
