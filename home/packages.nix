{
  pkgs,
  mbnvim,
  ...
}:
{
  home.packages = [
    pkgs.coreutils
    pkgs.eza # ls
    pkgs.bat # cat
    pkgs.ack # grep
    pkgs.fd # find
    pkgs.fswatch
    pkgs.fzf
    pkgs.ripgrep
    pkgs.jq
    pkgs.yq
    pkgs.delta
    pkgs.gnupg
    pkgs.ffmpeg
    pkgs.graphviz
    pkgs.imagemagick
    pkgs.kitty # mainly for kitten icat
    pkgs.gh
    pkgs.awscli2
    pkgs.aws-sam-cli
    pkgs.docker
    pkgs.pipx
    pkgs.uv
    pkgs.presenterm
    pkgs.sketchybar-app-font
    pkgs.nixpkgs-review
    pkgs.nix-output-monitor
    pkgs.glow
    # pkgs.ggshield
    pkgs.okta-aws-cli
    pkgs.nixfmt-rfc-style
    pkgs.nix-tree
    pkgs.rainfrog
    pkgs.neofetch
    pkgs.speedtest-cli
    pkgs.yt-dlp
    pkgs.shellcheck
    # pkgs.bruno
    pkgs.claude-code
    pkgs.opencode
    pkgs.amazon-q-cli
    pkgs.aws-sso-util
    pkgs.awscurl
    pkgs.rain # cfn tools
    pkgs.cfn-transform # local sam transform
    pkgs.former # cfn snippets cli
    pkgs.aws-whoami
    pkgs.mergiraf
    mbnvim
  ];
}
