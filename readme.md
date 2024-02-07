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

## Troubleshooting

If you get the following error:

```
could not write domain com.apple.universalaccess
```

Open System Preferences -> Security & Privacy -> Full Disk Access.
Find "Terminal" and check the box next to it.
Then retry the `darwin-rebuild switch` command.
