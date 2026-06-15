{ ... }:
{
  flake.modules.homeManager.tmux =
    { pkgs, config, ... }:
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
        extraConfig = ''
          set-option -gu default-command
          set-option -g default-shell ${pkgs.zsh}/bin/zsh
          source-file ${config.xdg.configHome}/tmux/tmux.local.conf
        '';
      };
      xdg.configFile."tmux/tmux.local.conf".source =
        config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/system.nix/modules/tmux/tmux.conf";
      home.file.tmux-resizer = {
        enable = true;
        source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/system.nix/modules/tmux/tmux-resizer.sh";
        target = ".local/bin/tmux-resizer.sh";
      };
      home.file.tmux-new-session = {
        enable = true;
        source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/system.nix/modules/tmux/tmux-new-session.sh";
        target = ".local/bin/tmux-new-session.sh";
      };
      home.file.tmux-list-sessions = {
        enable = true;
        source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/system.nix/modules/tmux/tmux-list-sessions.sh";
        target = ".local/bin/tmux-list-sessions.sh";
      };
      home.file.tmux-sessionizer = {
        enable = true;
        source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/system.nix/modules/tmux/tmux-sessionizer.sh";
        target = ".local/bin/tmux-sessionizer.sh";
      };
    };
}
