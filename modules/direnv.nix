{ ... }:
{
  flake.modules.homeManager.direnv =
    { pkgs, lib, ... }:
    {
      programs.direnv = {
        package = lib.warn "direnv: doCheck disabled — remove override once nixpkgs cache catches up" (pkgs.direnv.overrideAttrs { doCheck = false; });
        enable = true;
        enableBashIntegration = true;
        enableZshIntegration = true;
        nix-direnv.enable = true;
        config = {
          global = {
            hide_env_diff = true;
            warn_timeout = "0s";
          };
        };
      };
    };
}
