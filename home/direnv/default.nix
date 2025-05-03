{
  pkgs,
  ...
}:
{
  programs.direnv = {
    package = pkgs.direnv;
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
}
