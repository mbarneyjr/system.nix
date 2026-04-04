{ ... }:
{
  flake.modules.homeManager.ghostty = {
    home.file.ghostty = {
      enable = true;
      source = ./config;
      target = ".config/ghostty/config";
    };
  };
}
