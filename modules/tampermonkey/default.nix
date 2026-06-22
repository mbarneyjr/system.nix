{ lib, ... }:
let
  scriptDir = ./.;
  scripts = lib.filter (lib.hasSuffix ".user.js") (lib.attrNames (builtins.readDir scriptDir));
in
{
  flake.modules.homeManager.tampermonkey =
    { config, pkgs, ... }:
    lib.mkIf pkgs.stdenv.isDarwin {
      programs.google-chrome = {
        enable = true;
        # Chrome is the Homebrew cask
        package = null;
        extensions = [
          { id = "dhdgffkkebhmkfjojejmpbldmpobfkfo"; } # Tampermonkey (classic stable)
        ];
      };

      home.packages = [
        (pkgs.writeShellScriptBin "tampermonkey-load-scripts" ''
          open -a "Google Chrome" \
            ${builtins.concatStringsSep " \\\n    " (
              map (f: "\"file://${config.home.homeDirectory}/.config/tampermonkey/${f}\"") scripts
            )}
        '')
      ];

      home.file.".config/tampermonkey".source = lib.sourceFilesBySuffices scriptDir [ ".user.js" ];
    };
}
