{ pkgs, unstable, ... }:

{
  package = unstable.tmux;
  enable = true;
  baseIndex = 1;
  mouse = true;
  keyMode = "vi";
  customPaneNavigationAndResize = true;
  extraConfig = ''
    set-option -g default-shell ${pkgs.zsh}/bin/zsh
  '' + builtins.readFile ./tmux.conf;
}
