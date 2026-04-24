{ lib, ... }:
let
  baseFonts = pkgs: [
    pkgs.source-code-pro
    pkgs.nerd-fonts.sauce-code-pro
    (pkgs.runCommand "sketchybar-app-font" { } ''
      mkdir -p $out/share/fonts/truetype
      cp ${./sketchybar-app-font.ttf} $out/share/fonts/truetype/
    '')
  ];

  berkeleyMonoSource =
    cfg:
    fetchGit (
      {
        url = cfg.url;
        ref = cfg.ref;
      }
      // lib.optionalAttrs (cfg.rev != null) {
        rev = cfg.rev;
      }
    );

  berkeleyMonoPackage =
    pkgs: cfg:
    pkgs.stdenvNoCC.mkDerivation {
      pname = "berkeley-mono";
      version = if cfg.rev != null then lib.substring 0 7 cfg.rev else cfg.ref;
      src = berkeleyMonoSource cfg;
      dontUnpack = true;
      installPhase = ''
        runHook preInstall
        mkdir -p $out/share/fonts/opentype/BerkeleyMono
        font_count=$(find "$src"/${cfg.directory} -type f -name '*.otf' | wc -l | tr -d ' ')
        if [ "$font_count" -eq 0 ]; then
          echo "no Berkeley Mono .otf files found under $src/${cfg.directory}" >&2
          exit 1
        fi
        find "$src"/${cfg.directory} -type f -name '*.otf' | sort | while IFS= read -r font; do
          install -Dm644 "$font" $out/share/fonts/opentype/BerkeleyMono/
        done
        runHook postInstall
      '';
    };

  berkeleyMonoNerdFont =
    pkgs: cfg:
    let
      src = berkeleyMonoSource cfg;
    in
    pkgs.stdenvNoCC.mkDerivation {
      pname = "berkeley-mono-nerd-font";
      version = if cfg.rev != null then lib.substring 0 7 cfg.rev else cfg.ref;
      inherit src;
      dontUnpack = true;
      nativeBuildInputs = [ pkgs.nerd-font-patcher ];
      buildPhase = ''
        runHook preBuild
        mkdir -p patched
        font_count=$(find "$src"/${cfg.directory} -type f -name '*.otf' | wc -l | tr -d ' ')
        if [ "$font_count" -eq 0 ]; then
          echo "no Berkeley Mono .otf files found under $src/${cfg.directory}" >&2
          exit 1
        fi
        find "$src"/${cfg.directory} -type f -name '*.otf' | sort | while IFS= read -r font; do
          nerd-font-patcher --complete --outputdir patched "$font"
        done
        runHook postBuild
      '';
      installPhase = ''
        runHook preInstall
        mkdir -p $out/share/fonts/opentype/BerkeleyMonoNerdFont
        shopt -s nullglob
        for font in patched/*.otf; do
          install -Dm644 "$font" $out/share/fonts/opentype/BerkeleyMonoNerdFont/
        done
        runHook postInstall
      '';
    };
in
{
  flake.modules.darwin.fonts =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    {
      options.proprietary.berkeleyMono = {
        enable = lib.mkEnableOption "install the proprietary Berkeley Mono font";
        url = lib.mkOption {
          type = lib.types.str;
          default = "https://github.com/mbarneyjr/berkeley-mono.git";
        };
        ref = lib.mkOption {
          type = lib.types.str;
          default = "main";
        };
        rev = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
        };
        directory = lib.mkOption {
          type = lib.types.str;
          default = ".";
        };
      };

      config = {
        assertions = lib.optional config.proprietary.berkeleyMono.enable {
          assertion = config.proprietary.berkeleyMono.rev != null;
          message = ''
            proprietary.berkeleyMono.rev must be set when Berkeley Mono is enabled.
            Pure flake evaluation rejects an unlocked fetchGit on a floating branch tip.
          '';
        };

        fonts.packages =
          (baseFonts pkgs)
          ++ lib.optionals
            (config.proprietary.berkeleyMono.enable && config.proprietary.berkeleyMono.rev != null)
            [
              (berkeleyMonoPackage pkgs config.proprietary.berkeleyMono)
              (berkeleyMonoNerdFont pkgs config.proprietary.berkeleyMono)
            ];
      };
    };
}
