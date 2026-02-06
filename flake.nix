{
  description = "nix-darwin system flake";

  nixConfig = {
    extra-substituters = [
      "https://nix.barney.dev/"
      "https://cache.nixos.org/"
    ];
    extra-trusted-public-keys = [
      "nix.barney.dev-1:Wz6Nj2M/3PogEKI4/SRIdUm83QlC6zZN/0CCTS9oJ2o="
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin.url = "github:LnL7/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
    homebrew-core.url = "github:homebrew/homebrew-core";
    homebrew-core.flake = false;

    homebrew-cask.url = "github:homebrew/homebrew-cask";
    homebrew-cask.flake = false;

    mbnvim.url = "github:mbarneyjr/mbnvim";
    mbnvim.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    inputs@{ self, nixpkgs, ... }:
    let
      username = "mbarney";
      darwin-system = import ./system/darwin { inherit username inputs; };
      home = import ./system/home-manager { inherit username inputs; };
    in
    {
      darwinConfigurations = {
        x86_64 = darwin-system { system = "x86_64-darwin"; };
        aarch64 = darwin-system { system = "aarch64-darwin"; };
      };
      homeConfigurations = {
        x86_64 = home { system = "x86_64-linux"; };
        aarch64 = home { system = "aarch64-linux"; };
      };
      nixosConfigurations = {
        system76-gaze14 = import ./system/system76-gaze14 { inherit username inputs; };
      };
    };
}
