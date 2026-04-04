{ config, inputs, ... }:
let
  username = config.user.name;
in
{
  flake.modules.darwin.homebrew = darwinArgs: {
    imports = [ inputs.nix-homebrew.darwinModules.nix-homebrew ];
    nix-homebrew = {
      enable = true;
      enableRosetta = darwinArgs.config.nixpkgs.hostPlatform.system == "aarch64-darwin";
      user = username;
      taps = {
        "homebrew/homebrew-core" = inputs.homebrew-core;
        "homebrew/homebrew-cask" = inputs.homebrew-cask;
      };
      mutableTaps = false;
      autoMigrate = true;
    };
    homebrew = {
      enable = true;
      user = username;
      onActivation.cleanup = "zap";
      caskArgs.no_quarantine = true;
      global.brewfile = true;
      taps = builtins.attrNames darwinArgs.config.nix-homebrew.taps;
      casks = [
        "1password"
        "google-chrome"
        "spotify"
        "keybase"
        "tailscale-app"
        "discord"
        "slack"
        "obsidian"
        "protonvpn"
        "finch"
        "raycast"
        "parallels"
        "ticktick"
        "ghostty"
      ];
    };
  };
}
