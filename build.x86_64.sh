SYSTEM=$(uname -s)
if [ "$SYSTEM" = "Darwin" ]; then
  darwin-rebuild switch --flake ~/system.nix#x86_64
else
  nix --extra-experimental-features nix-command flakes run nixpkgs#home-manager -- switch --flake ~/system.nix#x86_64
fi
