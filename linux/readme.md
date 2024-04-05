# Nix on Linux

## Installation/Setup

- [install nix](https://nixos.org/download/#nix-install-linux)
- enable experimental features
  ```
  # /etc/nix/nix.conf
  experimental-features = nix-command flakes
  ```

...

- [install home-manager](https://nix-community.github.io/home-manager/index.xhtml#preface)

  ```
  nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
  nix-channel --update
  nix-shell '<home-manager>' -A install
  ```

- []
