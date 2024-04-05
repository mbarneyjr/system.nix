{ username, config, pkgs, mbnvim, ... }:

{
  home.username = username;
  home.homeDirectory = "/home/${username}";
  home.stateVersion = "23.05";
  home.packages = with pkgs; [
    neofetch
  ];
  programs.home-manager.enable = true;
}
