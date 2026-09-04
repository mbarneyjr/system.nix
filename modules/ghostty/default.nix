{ ... }:
{
  flake.modules.homeManager.ghostty =
    { lib, pkgs, ... }:
    {
      home.packages = lib.optional pkgs.stdenv.hostPlatform.isLinux pkgs.ghostty;
      home.file.ghostty = {
        enable = true;
        source = ./config;
        target = ".config/ghostty/config";
      };
    };
}
