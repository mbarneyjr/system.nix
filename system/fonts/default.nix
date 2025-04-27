{ pkgs, config, ... }:
{
  fonts.packages = [
    pkgs.source-code-pro
    (pkgs.nerdfonts.override {
      fonts = [
        "Meslo"
        "SourceCodePro"
      ];
    })
  ];
}
