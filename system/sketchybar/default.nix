{
  pkgs,
  config,
  ...
}:
{
  services.sketchybar.enable = true;
  services.sketchybar.config = ''
    CONFIG_DIR=${./.}
    ${builtins.readFile ./sketchybarrc}
  '';
}
