{ inputs, ... }:
{
  flake.modules.homeManager.dark-text =
    { pkgs, lib, ... }:
    let
      src = inputs.dark-text;
      fontconfig = pkgs.makeFontsConf { fontDirectories = [ pkgs.eb-garamond ]; };
      shader = pkgs.runCommand "shader.qsb" { } ''
        ${lib.getExe pkgs.kdePackages.qtshadertools} --qt6 -o $out ${src}/shaders/rays.frag
      '';
      sounds = map (lib.removeSuffix ".mp3") (builtins.attrNames (builtins.readDir "${src}/sounds"));
      overlays = map (lib.removeSuffix ".qml") (builtins.attrNames (builtins.readDir "${src}/shells"));
      quoted = names: lib.concatStringsSep " " (map (s: ''"${s}"'') names);
    in
    {
      home.packages = [
        (pkgs.writeShellApplication {
          name = "dark-text";
          runtimeInputs = with pkgs; [ quickshell sox ];
          bashOptions = [
            "errexit"
            "pipefail"
          ];
          text = ''
            export FONTCONFIG_FILE=${fontconfig}
            export TEXT_SHADER=${shader}

            SOUNDS=(${quoted sounds})
            OVERLAYS=(${quoted overlays})

            : "''${DARK_TEXT:=Hello, World!}"
            : "''${DARK_COLOR:-}"
            : "''${DARK_DURATION:=10000}"
            : "''${SOUND:=victory}"
            : "''${OVERLAY:=victory}"
            : "''${PLAY_SOUND:=true}"
            : "''${SHOW_OVERLAY:=true}"

            play_sound() {
                play "${src}/sounds/$1.mp3" >/dev/null 2>&1 &
            }

            show_overlay() {
              exec quickshell -p "${src}/shells/$1.qml" > /dev/null
            }

            contains() {
              local item=$1
              shift
              for x in "$@"; do
                if [[ "$x" == "$item" ]]; then
                  return 0
                fi
              done
              return 1
            }

            show_help() {
            if $PLAY_SOUND; then
              play_sound "help"
            fi
            cat <<EOF
            Usage: dark-text [OPTIONS]

            Options:
              -t, --text <TEXT>       Text to display [default: Hello, World!]
              -c, --color <COLOR>     Text color [default: #fad049]
              -d, --duration <MS>     Duration in milliseconds [default: 10000]
              -s, --sound             Sound to play [default: victory]
                                      Available sounds: ${lib.concatStringsSep " " sounds}
              -o, --overlay           Overlay to display [default: victory]
                                      Available overlays: ${lib.concatStringsSep " " overlays}
              -n, --no-sound          Don't play sound
              --no-display            Don't display overlay
              --death                 Dark souls death preset
              --new-area              Dark souls new area preset
              -h, --help              Print help
            EOF
            }

            while [[ $# -gt 0 ]]; do
              case "$1" in
                -t|--text)
                  DARK_TEXT="$2"
                  shift 2
                  ;;
                -c|--color)
                  DARK_COLOR="$2"
                  shift 2
                  ;;
                -d|--duration)
                  DARK_DURATION="$2"
                  shift 2
                  ;;
                -s|--sound)
                  if contains "$2" "''${SOUNDS[@]}"; then
                    SOUND="$2"
                  else
                    echo "Unknown sound. Available sounds: ''${SOUNDS[*]}"
                    exit 1
                  fi
                  shift 2
                  ;;
                -n|--no-sound)
                  PLAY_SOUND=false
                  shift
                  ;;
                -o|--overlay)
                  if contains "$2" "''${OVERLAYS[@]}"; then
                    OVERLAY="$2"
                  else
                    echo "Unknown overlay. Available overlays: ''${OVERLAYS[*]}"
                    exit 1
                  fi
                  shift 2
                  ;;
                --no-display)
                  SHOW_OVERLAY=false
                  shift
                  ;;
                --death)
                  SOUND="death"
                  DARK_DURATION=6500
                  DARK_COLOR="#A01212"
                  shift
                  ;;
                --new-area)
                  SOUND="new_area"
                  OVERLAY="new_area"
                  DARK_DURATION=4500
                  shift
                  ;;
                -h|--help)
                  show_help
                  exit 0
                  ;;
                *)
                  echo "Unknown option: $1"
                  show_help
                  exit 1
                  ;;
              esac
            done

            export DARK_TEXT DARK_COLOR DARK_DURATION

            if $PLAY_SOUND; then
                play_sound "$SOUND"
            fi

            if $SHOW_OVERLAY; then
              show_overlay "$OVERLAY"
            fi
          '';
        })
      ];
    };
}
