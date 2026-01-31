# Unified Repo Structure

Your existing repo could evolve to support macOS (darwin), standalone Linux (home-manager), AND NixOS:

```
system.nix/
├── flake.nix                 # Single flake with all outputs
├── flake.lock
│
├── home/                     # SHARED - works everywhere
│   ├── packages.nix          # User packages (use lib.optionals for platform-specific)
│   ├── zsh/
│   ├── git/
│   ├── tmux/
│   ├── direnv/
│   └── ghostty/
│
├── system/
│   ├── darwin/               # macOS-specific (nix-darwin)
│   │   ├── default.nix
│   │   ├── settings/
│   │   ├── homebrew/
│   │   └── aerospace/
│   │
│   └── nixos/                # NixOS-specific
│       ├── default.nix       # Base NixOS config
│       ├── desktop.nix       # KDE/GNOME settings
│       ├── laptop.nix        # Power management, wifi
│       └── server.nix        # Headless config
│
└── hosts/                    # Optional: per-machine overrides
    ├── macbook-pro.nix       # Darwin host
    ├── workstation.nix       # NixOS desktop
    └── thinkpad.nix          # NixOS laptop
```

## Unified flake.nix sketch

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    darwin.url = "github:lnl7/nix-darwin/master";
  };

  outputs = { self, nixpkgs, home-manager, darwin, ... }@inputs:
    let
      # Shared home-manager config
      homeManagerModule = {
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          users.mbarney = import ./home;
        };
      };
    in
    {
      # macOS (your existing darwin configs)
      darwinConfigurations = {
        aarch64 = darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          modules = [
            ./system/darwin
            home-manager.darwinModules.home-manager
            homeManagerModule
          ];
        };
      };

      # NixOS
      nixosConfigurations = {
        default = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./system/nixos
            home-manager.nixosModules.home-manager
            homeManagerModule
          ];
        };
      };

      # Standalone home-manager (non-NixOS Linux)
      homeConfigurations = {
        "mbarney@linux" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          modules = [ ./home ];
        };
      };
    };
}
```

## Making home/ cross-platform

The main changes needed in your existing home/ modules:

1. **Use conditionals for platform-specific packages:**

```nix
home.packages = with pkgs; [
  ripgrep fd jq  # everywhere
] ++ lib.optionals stdenv.isDarwin [
  # macOS-only
] ++ lib.optionals stdenv.isLinux [
  # Linux-only
];
```

2. **Conditional program configs:**

```nix
programs.alacritty = lib.mkIf pkgs.stdenv.isLinux {
  enable = true;
};
```

3. **Different paths:**

```nix
home.homeDirectory =
  if pkgs.stdenv.isDarwin
  then "/Users/mbarney"
  else "/home/mbarney";
```

## Workflow Summary

| System | Command |
|--------|---------|
| macOS | `./build.sh` or `darwin-rebuild switch --flake .#aarch64` |
| NixOS | `sudo nixos-rebuild switch --flake .#default` |
| Linux (non-NixOS) | `home-manager switch --flake .#mbarney@linux` |

All three share the same `home/` modules!
