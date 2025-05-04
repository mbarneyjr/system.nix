nix run --extra-experimental-features nix-command --extra-experimental-features flakes nix-darwin/nix-darwin-24.11#darwin-rebuild -- switch --flake ~/system.nix#x86_64
