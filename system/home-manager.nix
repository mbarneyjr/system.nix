{ inputs, username, ... }:
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
      (import ./overlays/former.nix)
      (import ./overlays/aws-whoami.nix)
    ];
  };
in
inputs.home-manager.lib.homeManagerConfiguration {
  inherit pkgs;
  extraSpecialArgs = {
    mbnvim = inputs.mbnvim.packages.${system}.default;
    inherit inputs username;
  };
  modules = [
    ../home
  ];
}
