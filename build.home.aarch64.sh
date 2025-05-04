nix run \
  --extra-experimental-features nix-command \
  --extra-experimental-features flakes \
  home-manager/release-24.11 -- switch --flake ~/system.nix#aarch64
