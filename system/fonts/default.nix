{ pkgs, config, ... }:
{
  fonts.packages = [
    pkgs.source-code-pro
    pkgs.nerd-fonts.sauce-code-pro
  ];
}
