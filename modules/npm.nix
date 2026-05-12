{ ... }:
{
  flake.modules.homeManager.npm =
    { config, ... }:
    {
      home.file.".config/npm/npmrc".text = ''
        min-release-age=7
      '';
      home.sessionVariables.NPM_CONFIG_GLOBALCONFIG = "${config.home.homeDirectory}/.config/npm/npmrc";
    };
}
