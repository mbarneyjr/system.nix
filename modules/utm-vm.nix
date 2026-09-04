{ config, ... }:
let
  username = config.user.name;
in
{
  flake.modules.nixos.utm-vm =
    { pkgs, ... }:
    {
      nixpkgs.hostPlatform = "aarch64-linux";
      nixpkgs.overlays = [
        (final: prev: {
          ghostty = prev.symlinkJoin {
            name = "ghostty-zink";
            paths = [ prev.ghostty ];
            nativeBuildInputs = [ prev.makeWrapper ];
            postBuild = ''
              wrapProgram $out/bin/ghostty \
                --set MESA_LOADER_DRIVER_OVERRIDE zink
            '';
          };
        })
      ];
      image.modules.qemu-efi.virtualisation.diskSize = 20480;

      time.timeZone = "America/Indianapolis";

      boot.kernelParams = [ "video=Virtual-1:2560x1600" ];
      boot.loader.timeout = 0;
      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;
      fileSystems."/" = {
        device = "/dev/disk/by-label/nixos";
        fsType = "ext4";
      };
      fileSystems."/boot" = {
        device = "/dev/disk/by-label/ESP";
        fsType = "vfat";
      };

      hardware.graphics.enable = true;
      environment.systemPackages = [
        pkgs.vulkan-tools
        pkgs.mesa-demos
      ];

      networking.hostName = "nixos-sandbox";
      services.spice-vdagentd.enable = true;
      services.openssh.enable = true;
      services.avahi = {
        enable = true;
        publish.enable = true;
        publish.addresses = true;
      };
      users.users.${username}.initialPassword = "nixos";

      home-manager.users.${username} =
        { pkgs, ... }:
        {
          wayland.windowManager.hyprland.extraLuaFiles.monitor = ''
            hl.monitor({ output = "", mode = "2560x1600@60", position = "auto", scale = 1 })
          '';

          # fix copy/paste between guest and host
          home.packages = [
            pkgs.xclip
            pkgs.wl-clipboard
            pkgs.clipnotify
          ];
          systemd.user.services.spice-vdagent = {
            Unit = {
              Description = "SPICE guest session agent (clipboard, resize, etc.)";
              PartOf = [ "graphical-session.target" ];
              After = [ "graphical-session.target" ];
            };
            Service = {
              ExecStart = "${pkgs.spice-vdagent}/bin/spice-vdagent -x";
              Restart = "on-failure";
            };
            Install.WantedBy = [ "graphical-session.target" ];
          };
          systemd.user.services.clipboard-sync-wayland-to-x11 = {
            Unit = {
              Description = "Mirror Wayland clipboard into X11 (spice-vdagent reads X11 only)";
              PartOf = [ "graphical-session.target" ];
              After = [ "graphical-session.target" ];
            };
            Service = {
              ExecStart = "${pkgs.wl-clipboard}/bin/wl-paste --watch ${pkgs.xclip}/bin/xclip -selection clipboard -i";
              Restart = "on-failure";
            };
            Install.WantedBy = [ "graphical-session.target" ];
          };
          systemd.user.services.clipboard-sync-x11-to-wayland = {
            Unit = {
              Description = "Mirror X11 clipboard into Wayland (host paste never reaches native Wayland clients otherwise)";
              PartOf = [ "graphical-session.target" ];
              After = [ "graphical-session.target" ];
            };
            Service = {
              ExecStart = pkgs.writeShellScript "x11-to-wayland-clipboard" ''
                while ${pkgs.clipnotify}/bin/clipnotify -s clipboard; do
                  ${pkgs.xclip}/bin/xclip -o -selection clipboard | ${pkgs.wl-clipboard}/bin/wl-copy
                done
              '';
              Restart = "on-failure";
            };
            Install.WantedBy = [ "graphical-session.target" ];
          };
        };
    };
}
