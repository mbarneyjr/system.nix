# shellcheck disable=SC2068

if [[ "$(uname -m)" == "x86_64" ]]; then
  ARCH="x86_64"
elif [[ "$(uname -m)" == "aarch64" ]]; then
  ARCH="aarch64"
elif [[ "$(uname -m)" == "arm64" ]]; then
  ARCH="aarch64"
else
  echo "Unsupported architecture: $(uname -m)"
  exit 1
fi

if [[ -d /etc/nixos ]]; then
  SYSTEM=${1:-$(cat /etc/system.nix/system 2>/dev/null)}
  if [[ -z "${SYSTEM}" ]]; then
    echo "When building for NixOS you must provide a system to build."
    exit 1
  fi
  REBOOT=${REBOOT:-}
  if [[ -z "${REBOOT}" ]]; then
    COMMAND="switch"
  else
    COMMAND="boot"
  fi
  echo "Building system.nix for NixOS system ${SYSTEM}..."
  sudo nixos-rebuild ${COMMAND} --flake "$HOME/system.nix#${SYSTEM}" ${@:2}
  exit 0
elif [[ "$(uname)" == "Darwin" ]]; then
  echo "Building system.nix for macOS on ${ARCH}..."
  sudo -H nix run \
    --extra-experimental-features 'nix-command flakes' \
    nix-darwin/master#darwin-rebuild -- \
    switch --flake ~/system.nix#${ARCH} ${@}
elif [[ "$(uname)" == "Linux" ]]; then
  echo "Building system.nix for Linux on ${ARCH}..."
  nix run \
    --extra-experimental-features 'nix-command flakes' \
    home-manager/release-24.11 -- \
    switch --flake ~/system.nix#${ARCH} \
    --extra-experimental-features 'nix-command flakes' \
    ${@}
else
  echo "Unsupported operating system: $(uname)"
  exit 1
fi
