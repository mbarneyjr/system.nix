SYSTEM=$(uname -s)
if [ "$SYSTEM" = "Darwin" ]; then
  nix run --extra-experimental-features nix-command --extra-experimental-features flakes nix-darwin/nix-darwin-24.11#darwin-rebuild -- switch --flake ~/system.nix#x86_64
else
  nix run --extra-experimental-features nix-command --extra-experimental-features flakes nixpkgs#home-manager -- switch --flake ~/system.nix#x86_64
fi
