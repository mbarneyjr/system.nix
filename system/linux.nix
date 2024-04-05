{ nixpkgs, nixpkgs-unstable, username, mbnvim, home-manager }:

{ system }:

home-manager.lib.homeManagerConfiguration {
  pkgs = nixpkgs.legacyPackages.aarch64-linux;
  extraSpecialArgs = {
    inherit username mbnvim;
    unstable = import nixpkgs-unstable {
      inherit system;
    };
  };
  modules = [
    ../home/linux.nix
  ];
}



