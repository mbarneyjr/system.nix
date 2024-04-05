SYSTEM=$(uname -s)
if [ "$SYSTEM" = "Darwin" ]; then
  darwin-rebuild switch --flake ~/system.nix#aarch64
else
  nix run nixpkgs#home-manager -- switch --flake ~/system.nix#aarch64
fi
