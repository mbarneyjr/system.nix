final: prev: {
  amazon-q-cli = prev.amazon-q-cli.overrideAttrs (old: {
    meta.platforms = prev.lib.platforms.darwin;
  });
}
