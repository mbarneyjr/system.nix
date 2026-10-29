{ ... }:
let
  overlayList = [ ];
in
{
  flake.modules = {
    darwin.overlays = {
      nixpkgs.overlays = overlayList;
      nixpkgs.config.allowUnfree = true;
    };

    nixos.overlays = {
      nixpkgs.overlays = overlayList;
      nixpkgs.config.allowUnfree = true;
    };

    homeManager.overlays = {
      nixpkgs.overlays = overlayList;
      nixpkgs.config.allowUnfree = true;
    };
  };
}
