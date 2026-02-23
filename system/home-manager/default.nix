{ inputs, username, ... }:
{ system }:
let
  pkgs = import inputs.nixpkgs {
    inherit system;
    config = {
      allowUnfree = true;
    };
    overlays = import ../../nix/overlays;
  };
in
inputs.home-manager.lib.homeManagerConfiguration {
  inherit pkgs;
  extraSpecialArgs = {
    mbnvim = inputs.mbnvim.packages.${system}.default;
    inherit inputs username;
  };
  modules = [
    ../../home
  ];
}
