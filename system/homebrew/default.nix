{
  config,
  username,
  inputs,
  system,
  ...
}:
{
  nix-homebrew = {
    enable = true;
    enableRosetta = system == "aarch64-darwin";
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
    taps = builtins.attrNames config.nix-homebrew.taps;
    casks = [
      "1password"
      "google-chrome"
      "spotify"
      "keybase"
      "tailscale-app"
      "discord"
      "slack"
      "obsidian"
      "shapr3d"
      "protonvpn"
      "docker-desktop"
      "raycast"
      "parallels"
      "ticktick"
      "ghostty"
    ];
  };
}
