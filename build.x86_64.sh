SYSTEM=$(uname -s)
if [ "$SYSTEM" = "Darwin" ]; then
  darwin-rebuild switch --flake ~/system.nix#x86_64
else
  nix run --extra-experimental-features nix-command --extra-experimental-features flakes nixpkgs#home-manager -- switch --flake ~/system.nix#x86_64
fi
