# NixOS Configuration
# This is a machine-agnostic "blueprint" configuration.
# Hardware-specific settings come from /etc/nixos/hardware-configuration.nix
#
# Apply with: sudo nixos-rebuild switch --flake /path/to/repo#default

{ config, pkgs, lib, ... }:

{
  imports = [
    # Hardware config lives outside the repo, generated per-machine with:
    #   nixos-generate-config --no-filesystems
    # The --no-filesystems flag is important because disko handles mounts.
    # This file provides kernel modules and hardware quirks detection.
    /etc/nixos/hardware-configuration.nix
  ];

  # ==========================================================================
  # BOOT
  # ==========================================================================

  # UEFI systems (most modern hardware) - uses systemd-boot
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Uncomment below (and comment above) for legacy BIOS systems:
  # boot.loader.grub.enable = true;
  # boot.loader.grub.device = "/dev/sda";  # or your boot disk

  # Use latest kernel (optional, default is LTS)
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # ==========================================================================
  # NETWORKING
  # ==========================================================================

  networking.hostName = "nixos";  # Change this per-machine if desired

  # NetworkManager handles wifi, ethernet, VPN - works well for laptop/desktop
  networking.networkmanager.enable = true;

  # Firewall - enabled by default, open ports as needed
  networking.firewall.enable = true;
  # networking.firewall.allowedTCPPorts = [ 22 80 443 ];

  # ==========================================================================
  # LOCALIZATION
  # ==========================================================================

  time.timeZone = "America/New_York";  # Change to your timezone

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # ==========================================================================
  # DESKTOP ENVIRONMENT
  # ==========================================================================

  # KDE Plasma 6 with Wayland
  services.desktopManager.plasma6.enable = true;

  # Display manager (login screen)
  services.displayManager = {
    sddm.enable = true;
    sddm.wayland.enable = true;
    defaultSession = "plasma";  # Auto-select Plasma Wayland
  };

  # XDG portal for Wayland screen sharing, file dialogs, etc.
  xdg.portal.enable = true;

  # ==========================================================================
  # AUDIO
  # ==========================================================================

  # PipeWire - modern audio stack (replaces PulseAudio)
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;  # PulseAudio compatibility
    # jack.enable = true;  # Uncomment for JACK support (pro audio)
  };

  # Disable PulseAudio (using PipeWire instead)
  hardware.pulseaudio.enable = false;

  # RealtimeKit for audio priority (reduces crackling)
  security.rtkit.enable = true;

  # ==========================================================================
  # HARDWARE SUPPORT
  # ==========================================================================

  # Bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;  # Bluetooth GUI manager

  # Graphics - let NixOS auto-detect, or uncomment for specific GPU:
  # hardware.graphics.enable = true;  # (enabled by default with desktop)

  # For NVIDIA (if you have one, uncomment and adjust):
  # services.xserver.videoDrivers = [ "nvidia" ];
  # hardware.nvidia.modesetting.enable = true;
  # hardware.nvidia.open = true;  # Use open-source kernel module (newer cards)

  # For AMD:
  # hardware.graphics.extraPackages = [ pkgs.amdvlk ];

  # ==========================================================================
  # LAPTOP-SPECIFIC (conditional)
  # ==========================================================================

  # Power management - good for laptops, harmless on desktops
  services.thermald.enable = true;  # Intel thermal management
  services.power-profiles-daemon.enable = true;  # Integrates with KDE

  # TLP for advanced power management (alternative to power-profiles-daemon)
  # Uncomment if you want more control, but disable power-profiles-daemon first
  # services.tlp.enable = true;

  # Lid/power button behavior (laptop)
  services.logind = {
    lidSwitch = "suspend";
    powerKey = "suspend";
  };

  # ==========================================================================
  # PRINTING
  # ==========================================================================

  services.printing.enable = true;

  # Auto-discovery of network printers
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  # ==========================================================================
  # DOCKER
  # ==========================================================================

  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
    # Use Docker rootless if you prefer (more secure, some limitations):
    # rootless = {
    #   enable = true;
    #   setSocketVariable = true;
    # };
  };

  # ==========================================================================
  # USER ACCOUNT
  # ==========================================================================

  users.users.mbarney = {
    isNormalUser = true;
    description = "mbarney";
    extraGroups = [
      "wheel"           # sudo access
      "networkmanager"  # manage network connections
      "docker"          # run docker without sudo
      "video"           # screen brightness control
      "audio"           # audio device access
    ];
    # You can set an initial password hash, or leave blank and set on first boot
    # Generate with: mkpasswd -m sha-512
    # initialHashedPassword = "...";

    # Or use a plain initial password (insecure, change immediately):
    initialPassword = "changeme";

    # Default shell
    shell = pkgs.zsh;
  };

  # ==========================================================================
  # SYSTEM PACKAGES
  # ==========================================================================

  # Allow unfree packages (NVIDIA drivers, some apps)
  nixpkgs.config.allowUnfree = true;

  # System-wide packages (prefer home-manager for user packages)
  environment.systemPackages = with pkgs; [
    # Essential CLI tools
    vim
    git
    curl
    wget
    htop

    # Filesystem tools
    ntfs3g      # NTFS support
    exfat       # exFAT support

    # Hardware diagnostics
    pciutils    # lspci
    usbutils    # lsusb
    lshw
  ];

  # ==========================================================================
  # PROGRAMS & SHELLS
  # ==========================================================================

  # ZSH
  programs.zsh.enable = true;

  # SSH
  programs.ssh.startAgent = true;

  # GPG
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = false;  # Set true if using GPG for SSH auth
  };

  # ==========================================================================
  # SERVICES
  # ==========================================================================

  # SSH daemon (disabled by default for desktop, enable if needed)
  services.openssh = {
    enable = false;  # Set to true to enable SSH access
    settings = {
      PasswordAuthentication = false;  # Key-only auth (more secure)
      PermitRootLogin = "no";
    };
  };

  # Firmware updates
  services.fwupd.enable = true;

  # ==========================================================================
  # NIX SETTINGS
  # ==========================================================================

  nix = {
    settings = {
      # Enable flakes
      experimental-features = [ "nix-command" "flakes" ];

      # Optimize storage
      auto-optimise-store = true;

      # Substituters (binary caches)
      substituters = [
        "https://cache.nixos.org"
        "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };

    # Garbage collection
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
  };

  # ==========================================================================
  # SYSTEM STATE VERSION
  # ==========================================================================

  # This determines the NixOS release defaults for stateful data.
  # Changing this after install may cause issues - leave it at your install version.
  # It does NOT affect package versions (those come from your flake inputs).
  system.stateVersion = "24.11";
}
