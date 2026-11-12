{ ... }:
{
  flake.modules.homeManager.rex =
    { lib, pkgs, ... }:
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
      switchSession = pkgs.writeShellApplication {
        name = "rex-switch-session";
        runtimeInputs = [
          pkgs.fzf
          pkgs.jq
        ];
        text = builtins.readFile ./rex-switch-session.sh;
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
        switchSession
        newSession
      ];
      programs.zsh.initContent = ''
        if [ -n "$REX_BIN_DIR" ]; then
          export PATH="$REX_BIN_DIR:$PATH"
        fi

        rex-clear() {
          rex session ls | awk -v group="$1" 'NR > 1 && index($1, group "/") == 1 { print $NF }' | xargs rex session kill
        }
      '';
      home.activation.rexCustomThemes = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        run /usr/bin/defaults write com.superlogical.rex Workspace.customThemes -data "$(${pkgs.xxd}/bin/xxd -p -c 0 ${./custom-themes.json})"
      '';
      targets.darwin.defaults."com.superlogical.rex" = {
        "Workspace.darkThemeID" = "custom-tokyonight";
        "Workspace.lightThemeID" = "custom-tokyonight-day";
        "Workspace.interfaceStyle" = "blendTheme";
        "Workspace.paneDensity" = "comfortable";
        "Workspace.inactivePaneFadeMode" = "both";
        "Workspace.darkUsesExtendedThemePalette" = true;
        "Workspace.lightUsesExtendedThemePalette" = true;
        "Workspace.animationStyle" = "natural";
        "Workspace.appIcon" = "default";
        "Workspace.cursorShader" = "warp";
        "Workspace.cursorShadersEnabled" = false;
        "Workspace.shellIconTheme" = "themedAlt";
        "Workspace.showsActivePaneBorder" = true;
        "Workspace.showsPaneHeaders" = false;
        "Workspace.sidebarCollapsed" = false;
        "Workspace.sidebarPosition" = "left";
        "Workspace.smoothResizeEnabled" = true;
        "Workspace.tabIconCount" = 3;
        "Workspace.tabIconTintMode" = "off";
        "Workspace.tabStyle" = "horizontal";
        "Workspace.tabsFillAvailableSpace" = false;
        "Workspace.terminalAllowsLigatures" = false;
        "Workspace.terminalCellHeightPercent" = 0.0;
        "Workspace.terminalCharacterSpacing" = "0";
        "Workspace.terminalFallbackFontNames" = [ ];
        "Workspace.terminalFontName" = "Berkeley Mono";
        "Workspace.terminalFontPointSize" = 20;
        "Workspace.terminalImproveTextContrast" = false;
        "Workspace.terminalFontSmoothing" = true;
        "Workspace.terminalPaddingColor" = "extend";
        "Workspace.terminalPaddingX" = 4.0;
        "Workspace.terminalPaddingY" = 0.0;
        "Workspace.terminalSmoothScrolling" = true;
        "Workspace.terminalUsesDisplayP3" = true;
        "Workspace.terminalUseThemePalette" = false;
        "Workspace.tintsPanesWithProgramBackground" = true;
        "Workspace.usesPaneGlass" = true;
        "Workspace.usesStandardInactiveWindowPaneStyles" = true;
        "RexAppUpdateAutomation" = "install";
        "RexAppUpdateChannel" = "snapshot";
        "rex.agents.names-sessions" = true;
        "rex.client.remoteControl" = true;
        "rex.developer-mode-enabled" = true;
        "rex.server.automatic-restart-enabled" = true;
        "rex.server.block-plugin-reload-enabled" = false;
        "rex.server.run-mode" = "bundled";
        "rex.server.tailnet-enabled" = true;
        "rex.server.web-client-origin-patterns" = [ "https://rex.superlogical.com" ];
      };
      xdg.configFile."rex/navigator.lua".source = ./navigator.lua;
      xdg.configFile."rex/init.lua".text = ''
        local REX_SESSIONIZER = "${sessionizer}/bin/rex-sessionizer"
        local REX_SWITCH_SESSION = "${switchSession}/bin/rex-switch-session"
        local REX_NEW_SESSION = "${newSession}/bin/rex-new-session"
        ${builtins.readFile ./init.lua}
      '';
    };
}
