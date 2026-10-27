{ inputs, ... }:
{
  flake.modules.homeManager.packages =
    { pkgs, ... }:
    {
      home.packages = [
        inputs.mbnvim.packages.${pkgs.stdenv.hostPlatform.system}.default
        inputs.gcalsync.packages.${pkgs.stdenv.hostPlatform.system}.default
        pkgs.coreutils
        pkgs.curl
        pkgs.eza
        pkgs.bat
        pkgs.ack
        pkgs.fd
        pkgs.fswatch
        pkgs.fzf
        pkgs.tree
        pkgs.ripgrep
        pkgs.jq
        pkgs.delta
        pkgs.gnupg
        pkgs.ffmpeg
        pkgs.graphviz
        pkgs.imagemagick
        pkgs.kitty
        pkgs.gh
        pkgs.awscli2
        pkgs.uv
        pkgs.fastfetch
        pkgs._1password-cli
        pkgs.shellcheck
        pkgs.ssm-session-manager-plugin
        pkgs.mergiraf
      ];
    };
}
