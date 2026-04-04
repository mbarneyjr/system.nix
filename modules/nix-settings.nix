{ config, inputs, ... }:
let
  username = config.user.name;
in
{
  flake.modules.darwin.nix-settings =
    { pkgs, ... }:
    {
      system.stateVersion = 6;
      nix.enable = true;
      nix.package = pkgs.nix;
      nix.checkConfig = true;
      nix.nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];
      nix.gc = {
        automatic = true;
        interval = [
          {
            Hour = 0;
          }
        ];
        options = "--delete-older-than 30d";
      };
      nix.optimise = {
        automatic = true;
        interval = [
          {
            Hour = 0;
          }
        ];
      };
      nix.settings = {
        experimental-features = "nix-command flakes";
        substituters = [
          "https://nix.barney.dev/"
          "https://cache.nixos.org/"
        ];
        trusted-public-keys = [
          "nix.barney.dev-1:Wz6Nj2M/3PogEKI4/SRIdUm83QlC6zZN/0CCTS9oJ2o="
          "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        ];
        trusted-users = [
          "root"
          username
        ];
      };
    };
}
