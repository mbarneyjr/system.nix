{
  pkgs,
  config,
  inputs,
  system,
  username,
  unstable,
  ...
}:
{
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.extraSpecialArgs = {
    glimpse = inputs.glimpse.packages.${system}.default;
    mbnvim = inputs.mbnvim.packages.${system}.default;
    inherit unstable;
  };
  home-manager.users.${username} = {
    home.stateVersion = "24.11";
    imports = [
      ./packages.nix
      ./zsh
      ./direnv
      ./git
      ./tmux
      ./ghostty
      ./awsume
    ];
  };
}
