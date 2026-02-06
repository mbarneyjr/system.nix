{
  username,
  inputs,
}:
let
  system = "x86_64-linux";
  pkgs = import inputs.nixpkgs {
    inherit system;
    config = {
      allowUnfree = true;
    };
    overlays = import ../../nix/overlays;
  };
in
inputs.nixpkgs.lib.nixosSystem {
  inherit system pkgs;
  specialArgs = {
    inherit system username;
  };
  modules = [
    ./hardware.nix
    {
      environment.etc."system.nix/system".text = "system76-gaze14";
    }
    inputs.home-manager.nixosModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.extraSpecialArgs = {
        mbnvim = inputs.mbnvim.packages.${system}.default;
      };
      home-manager.users.${username} = (import ../../home { inherit pkgs username; }) // {
        wayland.windowManager.hyprland = {
          enable = true;
          settings = {
            "$mod" = "SUPER";

            bind = [
              "$mod, RETURN, exec, ghostty"
              "$mod, D, exec, rofi -show drun"
              "$mod, Q, killactive"
              "$mod, F, fullscreen"
              "$mod, M, exit"
            ];

            monitor = ",preferred,auto,1";

            exec-once = [
              "waybar"
              "dunst"
            ];

            input = {
              kb_layout = "us";
              kb_options = "caps:escape";
            };
          };
        };
      };
    }

    {
      nix.enable = true;
      nix.package = pkgs.nix;
      nix.checkConfig = true;
      nix.nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];
      # nix.gc = {
      #   automatic = true;
      #   interval = [
      #     {
      #       Hour = 0;
      #     }
      #   ];
      #   options = "--delete-older-than 30d";
      # };
      # nix.optimise = {
      #   automatic = true;
      #   interval = [
      #     {
      #       Hour = 0;
      #     }
      #   ];
      # };
      nix.settings = {
        experimental-features = "nix-command flakes";
        substituters = [
          "https://nix.barney.dev/"
          "https://cache.nixos.org/"
        ];
        trusted-public-keys = [
          "nix.barney.dev-1:Wz6Nj2M/3PogEKI4/SRIdUm83QlC6zZN/0CCTS9oJ2o="
          "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        ];
        trusted-users = [
          "root"
          "${username}"
        ];
      };

      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;
      networking.hostName = "nixos";
      networking.networkmanager.enable = true;
      time.timeZone = "America/Indiana/Indianapolis";
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

      services.xserver.xkb = {
        layout = "us";
        variant = "";
        options = "caps:escape";
      };

      programs.zsh.enable = true;

      users.users.mbarney = {
        isNormalUser = true;
        description = "Michael Barney";
        shell = pkgs.zsh;
        extraGroups = [
          "wheel"
          "networkmanager"
        ];
        packages = [ ];
      };

      environment.systemPackages = [
        pkgs.neovim
        pkgs.ghostty
        pkgs.kitty
        pkgs.waybar
        pkgs.dunst
        pkgs.rofi
        pkgs.grim
        pkgs.slurp
        pkgs.wl-clipboard
        pkgs.git
      ];

      services.xserver.enable = true;
      programs.hyprland = {
        enable = true;
        xwayland.enable = true;
      };
      services.displayManager.sddm.enable = true;
      services.displayManager.sddm.wayland.enable = true;
      xdg.portal.enable = true;
      xdg.portal.extraPortals = [
        pkgs.xdg-desktop-portal-hyprland
      ];

      services.pipewire = {
        enable = true;
        pulse.enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
      };
      fonts.packages = [
        pkgs.nerd-fonts.fira-code
        pkgs.nerd-fonts.jetbrains-mono
      ];
    }
  ];
}
