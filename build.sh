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

NIX_FLAGS=( \
  --extra-experimental-features 'nix-command flakes' \
  --extra-substituters 'https://nix.barney.dev/ https://cache.nixos.org/' \
  --extra-trusted-public-keys 'nix.barney.dev-1:Wz6Nj2M/3PogEKI4/SRIdUm83QlC6zZN/0CCTS9oJ2o= cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=' \
)

if [[ "$(uname)" == "Darwin" ]]; then
  echo "Building system.nix for macOS on ${ARCH}..."
  sudo -H nix run \
    "${NIX_FLAGS[@]}" \
    nix-darwin/master#darwin-rebuild -- \
    switch --flake ~/system.nix#${ARCH} ${@}
fi

if [[ "$(uname)" == "Linux" ]]; then
  echo "Building system.nix for Linux on ${ARCH}..."
  nix run \
    "${NIX_FLAGS[@]}" \
    home-manager/release-24.11 -- \
    switch --flake ~/system.nix#${ARCH} \
    "${NIX_FLAGS[@]}" \
    ${@}
fi

# todo, nixOS
