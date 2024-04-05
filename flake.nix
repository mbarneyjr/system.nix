{
  description = "nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-23.11-darwin";

    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager/release-23.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-bundle = {
      url = "github:homebrew/homebrew-bundle";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };

    mbnvim = {
      url = "github:mbarneyjr/mbnvim";
      flake = false;
    };
  };

  outputs = inputs @ { self, nixpkgs, nix-darwin, nixpkgs-unstable, nix-homebrew, homebrew-core, homebrew-cask, homebrew-bundle, home-manager, mbnvim }:
    let
      username = "mbarney";
      darwin-system = import ./system/darwin.nix { inherit nix-darwin nixpkgs-unstable home-manager nix-homebrew homebrew-core homebrew-cask homebrew-bundle mbnvim username; };
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
