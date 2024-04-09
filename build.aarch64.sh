SYSTEM=$(uname -s)
if [ "$SYSTEM" = "Darwin" ]; then
  darwin-rebuild switch --flake ~/system.nix#aarch64
else
  nix --extra-experimental-features nix-command flake run nixpkgs#home-manager -- switch --flake ~/system.nix#aarch64
fi
