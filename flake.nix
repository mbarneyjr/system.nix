{
  description = "nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs @ { self, nixpkgs, nix-darwin, home-manager }:
    let
      username = "mbarney";
      darwin-system = import ./system/darwin.nix { inherit nix-darwin home-manager username; };
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
