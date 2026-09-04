let
  berkeleyMonoModule =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    let
      cfg = config.proprietary.berkeleyMono;
      src = fetchGit { inherit (cfg) url ref rev; };
      version = lib.substring 0 7 cfg.rev;
    in
    {
      options.proprietary.berkeleyMono = {
        url = lib.mkOption {
          type = lib.types.str;
          default = "https://github.com/mbarneyjr/berkeley-mono.git";
        };
        ref = lib.mkOption {
          type = lib.types.str;
          default = "main";
        };
        rev = lib.mkOption {
          type = lib.types.str;
          default = "cefdbcc46656894441902c8e64712e83420a9fa4";
        };
        directory = lib.mkOption {
          type = lib.types.str;
          default = ".";
        };
      };

      config.fonts.packages = [
        (pkgs.stdenvNoCC.mkDerivation {
          pname = "berkeley-mono";
          inherit version src;
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
        })

        (pkgs.stdenvNoCC.mkDerivation {
          pname = "berkeley-mono-nerd-font";
          inherit version src;
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
        })
      ];
    };
in
{
  flake.modules.darwin.berkeley-mono = berkeleyMonoModule;
  flake.modules.nixos.berkeley-mono = berkeleyMonoModule;
}
