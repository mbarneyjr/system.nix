{ pkgs, ... }:

{
  programs.tmux = {
    package = pkgs.tmux;
    enable = true;
    baseIndex = 1;
    mouse = true;
    keyMode = "vi";
    customPaneNavigationAndResize = true;
    plugins = [
    ];
    extraConfig =
      ''
        set-option -gu default-command
        set-option -g default-shell ${pkgs.zsh}/bin/zsh
      ''
      + builtins.readFile ./tmux.conf;
  };
  home.file.tmux-new-session = {
    enable = true;
    executable = true;
    source = ./tmux-new-session.sh;
    target = ".local/bin/tmux-new-session.sh";
  };
  home.file.tmux-list-sessions = {
    enable = true;
    executable = true;
    source = ./tmux-list-sessions.sh;
    target = ".local/bin/tmux-list-sessions.sh";
  };
  home.file.tmux-sessionizer = {
    enable = true;
    executable = true;
    source = ./tmux-sessionizer.sh;
    target = ".local/bin/tmux-sessionizer.sh";
  };
}
