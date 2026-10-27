{ ... }:
let
  overlayList = [
    (final: prev: {
      claude-code = prev.claude-code.overrideAttrs (
        old:
        let
          flag = "--set-default CLAUDE_CODE_CERT_STORE system ";
          strip = s: builtins.replaceStrings [ flag ] [ "" ] s;
          phases = [
            "installPhase"
            "postInstall"
            "postFixup"
          ];
          found = builtins.any (p: final.lib.hasInfix flag (old.${p} or "")) phases;
        in
        final.lib.warnIfNot found
          "claude-code overlay: CLAUDE_CODE_CERT_STORE flag not found; this overlay is now a no-op and can be removed"
          (final.lib.genAttrs (builtins.filter (p: old ? ${p}) phases) (p: strip old.${p}))
      );
    })
  ];
in
{
  flake.modules = {
    darwin.overlays = {
      nixpkgs.overlays = overlayList;
      nixpkgs.config.allowUnfree = true;
    };

    nixos.overlays = {
      nixpkgs.overlays = overlayList;
      nixpkgs.config.allowUnfree = true;
    };

    homeManager.overlays = {
      nixpkgs.overlays = overlayList;
      nixpkgs.config.allowUnfree = true;
    };
  };
}
