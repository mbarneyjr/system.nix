{ username, config, pkgs, mbnvim, ... }:

{
  home.username = username;
  home.homeDirectory = "/home/${username}";
  home.stateVersion = "23.05";
  home.packages = with pkgs; [
    neofetch
    neovim
  ];
  home.file.neovim = {
    enable = true;
    recursive = true;
    source = "${mbnvim}";
    target = ".config/nvim";
  };
  programs.home-manager.enable = true;
}
