{ pkgs, unstable, ... }:

{
  package = unstable.tmux;
  enable = true;
  baseIndex = 1;
  mouse = true;
  keyMode = "vi";
  customPaneNavigationAndResize = true;
  extraConfig = builtins.readFile ./tmux.conf;
}
