{
  nixpkgs,
  nixpkgs-unstable,
  username,
  mbnvim,
  home-manager,
}:

{ system }:

home-manager.lib.homeManagerConfiguration {
  pkgs = nixpkgs.legacyPackages."${system}";
  extraSpecialArgs = {
    inherit username mbnvim;
    unstable = import nixpkgs-unstable {
      inherit system;
      config = {
        allowUnfree = true;
      };
    };
  };
  modules = [
    ../home/linux.nix
  ];
}
