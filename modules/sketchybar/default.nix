{ ... }:
{
  flake.modules.darwin.sketchybar = {
    services.sketchybar.enable = true;
    services.sketchybar.config = ''
      CONFIG_DIR=${./.}
      ${builtins.readFile ./sketchybarrc}
    '';
  };
}
