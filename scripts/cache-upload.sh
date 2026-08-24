#!/usr/bin/env bash
set -euo pipefail

usage() {
  echo "Usage: $0 [--refresh] [path]"
  echo "  path      store path to sign and upload (default: ./result)"
  echo "  --refresh re-fetch the signing key from AWS Secrets Manager and update the keychain"
  exit 1
}

REFRESH=0
STORE_PATH="./result"

for arg in "$@"; do
  case "$arg" in
    --refresh) REFRESH=1 ;;
    -h|--help) usage ;;
    *) STORE_PATH="$arg" ;;
  esac
done

SECRET_ID="/nix/cache/signing-key"
KEYCHAIN_SERVICE="nix-cache-signing-key"
KEYCHAIN_ACCOUNT="$USER"
CACHE_URL="s3://nix.barney.dev?region=us-east-2"

if [[ "$REFRESH" -eq 1 ]]; then
  security delete-generic-password -a "$KEYCHAIN_ACCOUNT" -s "$KEYCHAIN_SERVICE" >/dev/null 2>&1 || true
fi

if ! security find-generic-password -a "$KEYCHAIN_ACCOUNT" -s "$KEYCHAIN_SERVICE" -w >/dev/null 2>&1; then
  echo "fetching signing key from AWS Secrets Manager..."
  secret=$(aws secretsmanager get-secret-value \
    --secret-id "$SECRET_ID" \
    --query SecretString \
    --output text)
  private_key=$(echo "$secret" | jq -r '.privateKey')
  security add-generic-password -U -a "$KEYCHAIN_ACCOUNT" -s "$KEYCHAIN_SERVICE" -w "$private_key"
  unset secret private_key
fi

echo "signing ${STORE_PATH}..."
nix store sign --verbose \
  --key-file <(security find-generic-password -a "$KEYCHAIN_ACCOUNT" -s "$KEYCHAIN_SERVICE" -w) \
  --recursive "$STORE_PATH"

echo "uploading to ${CACHE_URL}..."
nix copy --quiet --max-jobs auto --to "$CACHE_URL" "$STORE_PATH"

echo "successfully uploaded to cache at s3://nix.barney.dev"
