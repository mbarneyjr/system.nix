{ ... }:
{
  flake.modules.darwin.sketchybar =
    { lib, config, ... }:
    {
      services.sketchybar.config = lib.mkIf config.services.sketchybar.enable ''
        CONFIG_DIR=${./.}
        ${builtins.readFile ./sketchybarrc}
      '';
    };
}
