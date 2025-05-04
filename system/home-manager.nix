{ inputs, username, ... }:
{ system }:
let
  pkgs = import inputs.nixpkgs {
    inherit system;
    config = {
      allowUnfree = true;
    };
  };
  unstable = import inputs.nixpkgs-unstable {
    inherit system;
    config = {
      allowUnfree = true;
    };
  };
in
inputs.home-manager.lib.homeManagerConfiguration {
  inherit pkgs;
  extraSpecialArgs = {
    glimpse = inputs.glimpse.packages.${system}.default;
    mbnvim = inputs.mbnvim.packages.${system}.default;
    inherit inputs username unstable;
  };
  modules = [
    ../home
  ];
}
