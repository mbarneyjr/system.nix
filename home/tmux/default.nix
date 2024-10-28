{ pkgs, unstable, ... }:

{
  package = unstable.tmux;
  enable = true;
  baseIndex = 1;
  mouse = true;
  keyMode = "vi";
  customPaneNavigationAndResize = true;
  plugins = [
    pkgs.tmuxPlugins.vim-tmux-navigator
  ];
  extraConfig = ''
    set-option -gu default-command
    set-option -g default-shell ${pkgs.zsh}/bin/zsh
  '' + builtins.readFile ./tmux.conf;
}
