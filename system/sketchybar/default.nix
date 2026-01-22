{
  pkgs,
  config,
  username,
  ...
}:
{
  services.sketchybar.enable = true;
  services.sketchybar.config = ''
    CONFIG_DIR=${./.}
    ${builtins.readFile ./sketchybarrc}
  '';
  home-manager.users.${username}.home.packages = [
    pkgs.sketchybar-app-font
  ];
}
