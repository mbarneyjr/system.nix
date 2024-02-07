# system.nix

Nix, nix-darwin, home-manager setup for my development environment.

## Running

For intel-based macs:

```sh
$ darwin-rebuild switch --flake ~/system.nix#x86_64 
```

For Apple silicon-based macs:

```sh
$ darwin-rebuild switch --flake ~/system.nix#aarch64 
```
