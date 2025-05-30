# system.nix

Nix flake for macOS and Linux via nix-darwin, NixOS, or Home Manager.

## Darwin Requirements

You may need to install rosetta and the xcode command-line tools with the following command:

```sh
$ softwareupdate --install-rosetta
$ xcode-select --install
```

Then, install nix.
The [`nix-installer`](https://github.com/DeterminateSystems/nix-installer) is the most convenient option.
It enables `nix-command` and `flake` experimental features by default and provides an uninstaller.
If using the Determinate Systems nix installer, be sure to choose the nixos.org install option.

```sh
$ curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

## Running

```sh
$ ./build.sh
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
Find "Terminal" (or whatever terminal emulator you're using) and check the box next to it.
Then retry the `darwin-rebuild switch` command.
