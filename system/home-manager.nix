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
      (import ./overlays/amazon-q.nix)
    ];
  };
in
inputs.home-manager.lib.homeManagerConfiguration {
  inherit pkgs;
  extraSpecialArgs = {
    glimpse = inputs.glimpse.packages.${system}.default;
    mbnvim = inputs.mbnvim.packages.${system}.default;
    inherit inputs username;
  };
  modules = [
    ../home
  ];
}
