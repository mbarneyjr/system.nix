{
  pkgs,
  config,
  unstable,
  ...
}:
{
  services.aerospace.enable = true;
  services.aerospace.package = unstable.aerospace;
  services.aerospace.settings = {
    after-login-command = [ ];
    after-startup-command = [ ];
    enable-normalization-flatten-containers = true;
    enable-normalization-opposite-orientation-for-nested-containers = true;
    accordion-padding = 30;
    default-root-container-layout = "tiles";
    default-root-container-orientation = "horizontal";
    key-mapping.preset = "qwerty";
    on-focused-monitor-changed = [ "move-mouse monitor-lazy-center" ];
    gaps = {
      inner.horizontal = 0;
      inner.vertical = 0;
      outer.left = 0;
      outer.bottom = 0;
      outer.top = 0;
      outer.right = 0;
    };
    mode.main.binding = {
      alt-slash = "layout tiles horizontal vertical";
      alt-comma = "layout accordion horizontal vertical";
      alt-h = "focus left";
      alt-j = "focus down";
      alt-k = "focus up";
      alt-l = "focus right";
      alt-shift-h = "move left";
      alt-shift-j = "move down";
      alt-shift-k = "move up";
      alt-shift-l = "move right";
      alt-shift-minus = "resize smart -50";
      alt-shift-equal = "resize smart +50";
      alt-1 = "workspace 1";
      alt-2 = "workspace 2";
      alt-3 = "workspace 3";
      alt-4 = "workspace 4";
      alt-5 = "workspace 5";
      alt-6 = "workspace 6";
      alt-7 = "workspace 7";
      alt-8 = "workspace 8";
      alt-9 = "workspace 9";
      alt-shift-1 = "move-node-to-workspace 1";
      alt-shift-2 = "move-node-to-workspace 2";
      alt-shift-3 = "move-node-to-workspace 3";
      alt-shift-4 = "move-node-to-workspace 4";
      alt-shift-5 = "move-node-to-workspace 5";
      alt-shift-6 = "move-node-to-workspace 6";
      alt-shift-7 = "move-node-to-workspace 7";
      alt-shift-8 = "move-node-to-workspace 8";
      alt-shift-leftSquareBracket = "move-workspace-to-monitor --wrap-around next";
      alt-shift-rightSquareBracket = "move-workspace-to-monitor --wrap-around prev";
    };
    mode.service.binding = {
      esc = [
        "reload-config"
        "mode main"
      ];
      alt-shift-h = [
        "join-with left"
        "mode main"
      ];
      alt-shift-j = [
        "join-with down"
        "mode main"
      ];
      alt-shift-k = [
        "join-with up"
        "mode main"
      ];
      alt-shift-l = [
        "join-with right"
        "mode main"
      ];
    };
    on-window-detected = [
      {
        "if".app-id = "com.tinyspeck.slackmacgap";
        run = "move-node-to-workspace 1";
      }
      {
        "if".app-id = "com.apple.Notes";
        run = "move-node-to-workspace 1";
      }
      {
        "if".app-id = "com.google.Chrome";
        run = "move-node-to-workspace 2";
      }
      {
        "if".app-id = "net.kovidgoyal.kitty";
        run = "move-node-to-workspace 3";
      }
      {
        "if".app-id = "com.mitchellh.ghostty";
        run = "move-node-to-workspace 3";
      }
    ];
  };
}
