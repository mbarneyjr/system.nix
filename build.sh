# shellcheck disable=SC2068

if [[ "$(uname -m)" == "x86_64" ]]; then
  ARCH="x86-64"
elif [[ "$(uname -m)" == "aarch64" ]]; then
  ARCH="aarch64"
elif [[ "$(uname -m)" == "arm64" ]]; then
  ARCH="aarch64"
else
  echo "Unsupported architecture: $(uname -m)"
  exit 1
fi

if [[ "$(uname)" == "Darwin" ]]; then
  echo "Building system.nix for macOS on ${ARCH}..."
  sudo -H nix run \
    --extra-experimental-features 'nix-command flakes' \
    nix-darwin/master#darwin-rebuild -- \
    switch --flake ~/system.nix#${ARCH} ${@}
fi

if [[ "$(uname)" == "Linux" ]]; then
  echo "Building system.nix for Linux on ${ARCH}..."
  nix run \
    --extra-experimental-features 'nix-command flakes' \
    home-manager/release-24.11 -- \
    switch --flake ~/system.nix#${ARCH} ${@}
fi

# todo, nixOS
