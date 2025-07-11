{
  pkgs,
  config,
  username,
  ...
}:
{
  # enable touch id for sudo
  environment.etc."pam.d/sudo_local".text = ''
    # Managed by Nix Darwin
    auth       optional       ${pkgs.pam-reattach}/lib/pam/pam_reattach.so ignore_ssh
    auth       sufficient     pam_tid.so
  '';
  # security.pam.enableSudoTouchIdAuth = true;
  security.pam.services.sudo_local.touchIdAuth = true;

  # general system settings
  system.defaults = {
    ActivityMonitor = {
      IconType = 5;
      ShowCategory = 101;
      SortColumn = "CPUUsage";
    };
    NSGlobalDomain = {
      AppleShowAllFiles = true;
      AppleShowAllExtensions = true;
      AppleEnableMouseSwipeNavigateWithScrolls = false;
      AppleEnableSwipeNavigateWithScrolls = false;
      NSNavPanelExpandedStateForSaveMode = true;
      NSNavPanelExpandedStateForSaveMode2 = true;
      AppleInterfaceStyle = "Dark";
      InitialKeyRepeat = 10;
      KeyRepeat = 1;
      "com.apple.sound.beep.feedback" = 1;
      "com.apple.trackpad.forceClick" = false;
      _HIHideMenuBar = false;
    };
    SoftwareUpdate = {
      AutomaticallyInstallMacOSUpdates = true;
    };
    menuExtraClock = {
      ShowAMPM = true;
      ShowDayOfMonth = true;
      ShowDayOfWeek = true;
      ShowDate = 1;
      ShowSeconds = true;
    };
    controlcenter = {
      BatteryShowPercentage = true;
      Sound = true;
      Bluetooth = true;
      AirDrop = true;
      Display = true;
      NowPlaying = true;
    };
    dock = {
      autohide = true;
      autohide-delay = 0.0;
      autohide-time-modifier = 0.0;
      expose-group-apps = true;
      orientation = "left";
      tilesize = 32;
      mru-spaces = false;
      persistent-apps = [
        "/System/Applications/Launchpad.app"
        "/System/Applications/System Settings.app"
        "/System/Applications/Messages.app"
        "/System/Applications/Notes.app"
        "/Applications/Obsidian.app"
        "/Applications/TickTick.app"
        "/Applications/Slack.app"
        "/Applications/Google Chrome.app"
        "/Applications/Ghostty.app"
      ];
    };
    finder = {
      ShowStatusBar = true;
      ShowPathbar = true;
      ShowExternalHardDrivesOnDesktop = false;
      ShowHardDrivesOnDesktop = true;
      ShowMountedServersOnDesktop = true;
      AppleShowAllExtensions = true;
      AppleShowAllFiles = true;
      _FXShowPosixPathInTitle = true;
      _FXSortFoldersFirst = true;
      NewWindowTarget = "Other";
      NewWindowTargetPath = "file:///Users/${username}/Downloads";
    };
    screensaver = {
      askForPassword = true;
    };
    universalaccess = {
      closeViewScrollWheelToggle = true;
      reduceMotion = true;
    };
  };
  system.keyboard = {
    enableKeyMapping = true;
    remapCapsLockToEscape = true;
  };
}
