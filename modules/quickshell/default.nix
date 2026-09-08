{ inputs, ... }:
{
  flake.devShellPackages = builtins.mapAttrs (system: pkgs: [
    pkgs.kdePackages.qtdeclarative
  ]) inputs.nixpkgs.legacyPackages;

  flake.devShellEnv = builtins.mapAttrs (
    system: pkgs:
    let
      quickshell =
        if system == "aarch64-darwin" then
          inputs.nixpkgs.legacyPackages.aarch64-linux.quickshell
        else
          pkgs.quickshell;
    in
    {
      QML_IMPORT_PATH = "${pkgs.kdePackages.qtdeclarative}/lib/qt-6/qml:${quickshell}/lib/qt-6/qml";
    }
  ) inputs.nixpkgs.legacyPackages;

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
