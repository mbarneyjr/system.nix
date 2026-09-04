let
  fontsModule =
    { pkgs, ... }:
    {
      fonts.packages = [
        pkgs.source-code-pro
        pkgs.nerd-fonts.sauce-code-pro
        (pkgs.runCommand "sketchybar-app-font" { } ''
          mkdir -p $out/share/fonts/truetype
          cp ${./sketchybar-app-font.ttf} $out/share/fonts/truetype/
        '')
      ];
    };
in
{
  flake.modules.darwin.fonts = fontsModule;
  flake.modules.nixos.fonts = fontsModule;
}
