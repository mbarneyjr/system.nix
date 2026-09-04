{ config, ... }:
let
  username = config.user.name;
in
{
  flake.modules.nixos.hyprland =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      startHyprland = lib.getExe' config.programs.hyprland.package "start-hyprland";
    in
    {
      programs.hyprland.enable = true;
      fonts.enableDefaultPackages = true;

      services.greetd = {
        enable = true;
        settings = {
          default_session.command = "${pkgs.greetd}/bin/agreety --cmd ${startHyprland}";
          initial_session = {
            command = startHyprland;
            user = username;
          };
        };
      };
    };

  flake.modules.homeManager.hyprland = {
    wayland.windowManager.hyprland = {
      enable = true;
      configType = "lua";
      package = null;
      portalPackage = null;
      extraLuaFiles.config = ./config.lua;
    };
  };
}
