{
  description = "nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs @ { self, nix-darwin, nixpkgs }:
    let
      darwin-system = import ./system/darwin.nix { inherit nix-darwin; };
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
