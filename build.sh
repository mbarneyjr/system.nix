#!/usr/bin/env bash
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

NIX_FLAGS=(
  --extra-experimental-features 'nix-command flakes'
  --extra-substituters 'https://nix.barney.dev/ https://cache.nixos.org/'
  --extra-trusted-public-keys 'nix.barney.dev-1:Wz6Nj2M/3PogEKI4/SRIdUm83QlC6zZN/0CCTS9oJ2o= cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY='
)

HOST_FILE=~/system.nix/.hostname.local

if [[ "$(uname)" == "Darwin" ]]; then
  echo "Building system.nix for macOS on ${ARCH}..."
  sudo -H nix run \
    "${NIX_FLAGS[@]}" \
    nix-darwin/master#darwin-rebuild -- \
    switch --flake ~/system.nix#${ARCH} ${@}
fi

if [[ "$(uname)" == "Linux" && -f /etc/NIXOS ]]; then
  if [[ -n "${1}" && "${1}" != -* ]]; then
    HOST="${1}"
    shift
  elif [[ -f "${HOST_FILE}" ]]; then
    HOST="$(cat "${HOST_FILE}")"
  else
    echo "No hostname given and ${HOST_FILE} does not exist"
    echo "Usage: ./build.sh <hostname>"
    exit 1
  fi

  echo "Building system.nix for NixOS host ${HOST}..."
  if sudo -H nix run \
    "${NIX_FLAGS[@]}" \
    nixpkgs#nixos-rebuild -- \
    switch --flake ~/system.nix#"${HOST}" ${@}; then
    echo "${HOST}" >"${HOST_FILE}"
  fi
fi

if [[ "$(uname)" == "Linux" && ! -f /etc/NIXOS ]]; then
  echo "Building system.nix for Linux on ${ARCH}..."
  nix run \
    "${NIX_FLAGS[@]}" \
    home-manager/release-24.11 -- \
    switch --flake ~/system.nix#${ARCH} \
    "${NIX_FLAGS[@]}" \
    ${@}
fi
