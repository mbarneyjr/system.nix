{
  description = "nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-24.11-darwin";

    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin.url = "github:LnL7/nix-darwin/nix-darwin-24.11";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager/release-24.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
    homebrew-core.url = "github:homebrew/homebrew-core";
    homebrew-core.flake = false;

    homebrew-cask.url = "github:homebrew/homebrew-cask";
    homebrew-cask.flake = false;

    mbnvim.url = "github:mbarneyjr/mbnvim";
    mbnvim.flake = false;

    glimpse.url = "github:seatedro/glimpse";
  };

  outputs = inputs @ { self, ... }:
    let
      username = "mbarney";
      darwin-system = import ./system/darwin.nix { 
        username = username;
        nix-darwin = inputs.nix-darwin;
        nixpkgs-unstable = inputs.nixpkgs-unstable;
        home-manager = inputs.home-manager;
        nix-homebrew = inputs.nix-homebrew;
        homebrew-core = inputs.homebrew-core;
        homebrew-cask = inputs.homebrew-cask;
        mbnvim = inputs.mbnvim;
        glimpse = inputs.glimpse;
      };
    in
    {
      darwinConfigurations = {
        x86_64 = darwin-system {
          system = "x86_64-darwin";
        };
        aarch64 = darwin-system {
          system = "aarch64-darwin";
        };
      };
    };
}
