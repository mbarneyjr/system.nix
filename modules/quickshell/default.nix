{
  flake.modules.homeManager.quickshell =
    { pkgs, ... }:
    {
      programs.quickshell = {
        enable = true;
        systemd.enable = true;
      };

      xdg.configFile."quickshell/shell.qml" = {
        source = ./shell.qml;
        onChange = ''
          XDG_RUNTIME_DIR="''${XDG_RUNTIME_DIR:-/run/user/$(id -u)}" \
            ${pkgs.systemd}/bin/systemctl --user try-restart quickshell.service || true
        '';
      };
    };
}
