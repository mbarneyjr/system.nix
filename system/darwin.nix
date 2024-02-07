{ nix-darwin, home-manager, username }:

{ system }:

let
  configuration = { pkgs, ... }: {
    system.stateVersion = 4;
    services.nix-daemon.enable = true;
    nix.settings.experimental-features = "nix-command flakes";
    users.users.${username}.home = "/Users/${username}";

    environment.systemPackages = [ pkgs.vim pkgs.neovim pkgs.git ];

    programs.bash = {
      enable = true;
      enableCompletion = true;
    };
    programs.zsh = {
      enable = true;
      enableCompletion = true;
    };

    security.pam.enableSudoTouchIdAuth = true;
    system.defaults = {
      NSGlobalDomain.AppleInterfaceStyle = "Dark";
      NSGlobalDomain.InitialKeyRepeat = 10;
      NSGlobalDomain.KeyRepeat = 1;
      NSGlobalDomain."com.apple.sound.beep.feedback" = 1;
      dock.autohide = true;
      dock.autohide-delay = 0.0;
      dock.autohide-time-modifier = 0.0;
      dock.orientation = "left";
      dock.tilesize = 32;
      finder.AppleShowAllExtensions = true;
      finder.AppleShowAllFiles = true;
      finder._FXShowPosixPathInTitle = true;
      menuExtraClock.ShowSeconds = true;
      screensaver.askForPassword = true;
      universalaccess.closeViewScrollWheelToggle = true;
      universalaccess.reduceMotion = true;
    };
    system.keyboard.enableKeyMapping = true;
    system.keyboard.remapCapsLockToEscape = true;
  };
in
nix-darwin.lib.darwinSystem {
  inherit system;
  modules = [ 
    configuration
    home-manager.darwinModules.home-manager {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users.${username}.imports = [
        ({ pkgs, ... }: {
          home.stateVersion = "23.11";
          home.packages = [
            pkgs.git
            pkgs.neovim
            pkgs.neofetch
            pkgs.ripgrep
            pkgs.jq
            pkgs.fzf
            pkgs.gnupg
          ];
        })
      ];
    }
  ];
}
