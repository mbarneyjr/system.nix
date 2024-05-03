{ nix-darwin, home-manager, nixpkgs-unstable, nix-homebrew, homebrew-core, homebrew-cask, homebrew-bundle, mbnvim, username }:

{ system }:

let
  unstable = import nixpkgs-unstable {
    inherit system;
    config = {
      allowUnfree = true;
    };
  };
  configuration = { pkgs, ... }: {
    system.stateVersion = 4;
    services.nix-daemon.enable = true;
    nix.package = pkgs.nix;
    nix.settings.experimental-features = "nix-command flakes";
    nixpkgs.config = {
      allowUnfree = true;
    };
    users.users.${username}.home = "/Users/${username}";
    fonts.fontDir.enable = true;
    fonts.fonts = [
      (pkgs.nerdfonts.override { fonts = [ "Meslo" ]; })
    ];

    environment.shells = [
      pkgs.bashInteractive
    ];
    environment.systemPackages = [
      pkgs.vim
      pkgs.git
      pkgs.pam-reattach
      unstable.yabai
      unstable.skhd
    ];
    environment.etc."pam.d/sudo_local".text = ''
      # Managed by Nix Darwin
      auth       optional       ${pkgs.pam-reattach}/lib/pam/pam_reattach.so ignore_ssh
      auth       sufficient     pam_tid.so
    '';

    programs.zsh = {
      enable = true;
      enableCompletion = true;
    };

    services.yabai = {
      package = unstable.yabai;
      enable = true;
      enableScriptingAddition = true;
    };
    services.skhd = {
      enable = true;
      package = unstable.skhd;
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
      dock.mru-spaces = false;
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
    homebrew = {
      enable = true;
      caskArgs.no_quarantine = true;
      global.brewfile = true;
      masApps = { };
      casks = [
        "1password"
        "google-chrome"
        "spotify"
        "keybase"
        "tenor"
        "tailscale"
        "discord"
        "slack"
        "obsidian"
        "shapr3d"
        "protonvpn"
        "docker"
        "raycast"
        "parallels"
        "bruno"
        "ticktick"
      ];
    };
  };
  home-config = import ../home/darwin.nix;
in
nix-darwin.lib.darwinSystem {
  inherit system;
  modules = [
    configuration
    home-manager.darwinModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.extraSpecialArgs = {
        inherit unstable mbnvim;
      };
      home-manager.users.${username}.imports = [
        home-config
      ];
    }
    nix-homebrew.darwinModules.nix-homebrew
    {
      nix-homebrew = {
        enable = true;
        enableRosetta = system == "aarch64-darwin";
        user = username;
        taps = {
          "homebrew/homebrew-core" = homebrew-core;
          "homebrew/homebrew-bundle" = homebrew-bundle;
          "homebrew/homebrew-cask" = homebrew-cask;
        };
        mutableTaps = false;
        autoMigrate = true;
      };
    }
  ];
}
