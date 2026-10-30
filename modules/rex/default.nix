{ ... }:
{
  flake.modules.homeManager.rex =
    { pkgs, ... }:
    let
      sessionizer = pkgs.writeShellApplication {
        name = "rex-sessionizer";
        runtimeInputs = [
          pkgs.fzf
          pkgs.jq
          pkgs.findutils
        ];
        text = builtins.readFile ./rex-sessionizer.sh;
      };
      newSession = pkgs.writeShellApplication {
        name = "rex-new-session";
        runtimeInputs = [
          pkgs.git
          sessionizer
        ];
        text = builtins.readFile ./rex-new-session.sh;
      };
    in
    {
      home.packages = [
        sessionizer
        newSession
      ];
      programs.zsh.initContent = ''
        if [ -n "$REX_BIN_DIR" ]; then
          export PATH="$REX_BIN_DIR:$PATH"
        fi
      '';
      targets.darwin.defaults."com.superlogical.rex" = {
        "Workspace.darkThemeID" = "merino-dark";
        "Workspace.lightThemeID" = "merino-light";
        "Workspace.interfaceStyle" = "modern";
        "Workspace.paneDensity" = "compact";
        "Workspace.inactivePaneFadeMode" = "both";
        "Workspace.terminalFontPointSize" = 20;
        "Workspace.terminalSmoothScrolling" = true;
        "Workspace.terminalUsesDisplayP3" = false;
        "Workspace.terminalUseThemePalette" = false;
        "rex.client.remoteControl" = true;
      };
      xdg.configFile."rex/navigator.lua".source = ./navigator.lua;
      xdg.configFile."rex/init.lua".text = ''
        local REX_SESSIONIZER = "${sessionizer}/bin/rex-sessionizer"
        local REX_NEW_SESSION = "${newSession}/bin/rex-new-session"
        ${builtins.readFile ./init.lua}
      '';
    };
}
