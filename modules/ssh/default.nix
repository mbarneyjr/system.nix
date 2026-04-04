{ ... }:
{
  flake.modules.homeManager.ssh = {
    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;
      includes = [
        "~/.ssh/1password.config"
        "~/.ssh/ssm.config"
      ];
    };
    home.file.onepasswordSshConfig = {
      enable = true;
      target = ".ssh/1password.config";
      source = ./1password.config;
    };
    home.file.ssmConfig = {
      enable = true;
      target = ".ssh/ssm.config";
      source = ./ssm.config;
    };
  };
}
