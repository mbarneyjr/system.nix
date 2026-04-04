{ lib, config, ... }:
{
  options.user.name = lib.mkOption {
    type = lib.types.str;
    default = "mbarney";
  };

  config.flake.modules = {
    darwin.user =
      { pkgs, ... }:
      {
        system.primaryUser = config.user.name;
        users.users.${config.user.name} = {
          home = "/Users/${config.user.name}";
          shell = pkgs.zsh;
        };
      };

    homeManager.user =
      { pkgs, ... }:
      {
        home.stateVersion = "25.05";
        home.username = config.user.name;
        home.homeDirectory =
          if pkgs.stdenv.isDarwin then "/Users/${config.user.name}" else "/home/${config.user.name}";
        home.enableNixpkgsReleaseCheck = false;
      };
  };
}
