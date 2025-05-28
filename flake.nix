{
  description = "nix-darwin system flake";

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

    glimpse.url = "github:seatedro/glimpse";
    glimpse.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    inputs@{ self, ... }:
    let
      username = "mbarney";
      darwin-system = import ./system/darwin.nix { inherit username inputs; };
      home = import ./system/home-manager.nix { inherit username inputs; };
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
    };
}
