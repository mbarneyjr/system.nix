# system.nix

Nix, nix-darwin, home-manager setup for my development environment.

## First-Time Setup

You may need to install rosetta with the following command:

```sh
$ softwareupdate --install-rosetta
```

Then, install nix, by following the directions at [nixos.org](https://nixos.org/).

Next, insteall nix-darwin by following the directions at [nix-darwin](https://github.com/LnL7/nix-darwin).

## Running

For intel-based macs:

```sh
$ darwin-rebuild switch --flake ~/system.nix#x86_64
```

For Apple silicon-based macs:

```sh
$ darwin-rebuild switch --flake ~/system.nix#aarch64
```

## Post-Setup

### Keybase GPG

```sh
keybase pgp export|gpg --import -
keybase pgp export -s|gpg --allow-secret-key-import --import -
```

## Troubleshooting

If you get the following error:

```
could not write domain com.apple.universalaccess
```

Open System Preferences -> Security & Privacy -> Full Disk Access.
Find "Terminal" and check the box next to it.
Then retry the `darwin-rebuild switch` command.
