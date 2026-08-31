{ lib, ... }:
{
  options.flake.darwinConfigurations = lib.mkOption {
    type = lib.types.lazyAttrsOf lib.types.raw;
    default = { };
    description = "Instantiated nix-darwin configurations. Used by darwin-rebuild.";
  };
}
