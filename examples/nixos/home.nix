# Home Manager configuration for NixOS
#
# This shows how to reuse your existing home/ modules from your darwin setup.
# The key is using lib.mkIf with stdenv.isDarwin/isLinux for platform-specific bits.

{ config, pkgs, lib, ... }:

{
  # Basic home-manager settings
  home.username = "mbarney";
  home.homeDirectory = "/home/mbarney";

  # Home Manager state version (not the same as NixOS stateVersion)
  home.stateVersion = "24.11";

  # Let home-manager manage itself
  programs.home-manager.enable = true;

  # ============================================================================
  # OPTION 1: Import your existing modules directly
  # ============================================================================
  #
  # If your existing home/ modules are platform-agnostic, just import them:
  #
  # imports = [
  #   ../../home/packages.nix
  #   ../../home/zsh
  #   ../../home/git
  #   ../../home/tmux
  #   ../../home/direnv
  #   ../../home/ghostty
  # ];

  # ============================================================================
  # OPTION 2: Inline with platform conditionals
  # ============================================================================
  #
  # For settings that differ by platform, use mkIf:

  home.packages = with pkgs; [
    # Cross-platform packages
    ripgrep
    fd
    jq
    fzf
    tree
    wget
    curl

    # Linux-only packages
  ] ++ lib.optionals stdenv.isLinux [
    # GUI apps (typically Linux-only in home-manager, macOS uses Homebrew)
    firefox
    # vscode  # or use programs.vscode for declarative config
  ];

  # ============================================================================
  # PROGRAMS (work the same across platforms)
  # ============================================================================

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    # Your existing zsh config should work here
    # shellAliases = { ... };
    # initExtra = ''...'';
  };

  programs.git = {
    enable = true;
    userName = "Your Name";
    userEmail = "your@email.com";
    # ... rest of your git config
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  programs.tmux = {
    enable = true;
    # ... your tmux config
  };

  # ============================================================================
  # PLATFORM-SPECIFIC EXAMPLE
  # ============================================================================

  # Example: Different config per platform
  programs.alacritty = lib.mkIf pkgs.stdenv.isLinux {
    enable = true;
    # Linux-specific alacritty settings
  };

  # Example: Conditional based on hostname or other factors
  # home.file.".config/special" = lib.mkIf (config.home.username == "mbarney") {
  #   source = ./special-config;
  # };
}
