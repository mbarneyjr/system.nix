{
  pkgs,
  mbnvim,
  glimpse,
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
    pkgs.presenterm
    # pkgs.ggshield
    pkgs.nixfmt-rfc-style
    pkgs.nix-tree
    pkgs.rainfrog
    pkgs.neofetch
    pkgs.speedtest-cli
    pkgs.yt-dlp
    pkgs.bruno
    pkgs.claude-code
    pkgs.amazon-q-cli
    pkgs.aws-sso-util
    pkgs.awscurl
    pkgs.rain # cfn tools
    pkgs.cfn-transform # local sam transform
    pkgs.former # cfn snippets cli
    pkgs.aws-whoami
    pkgs.mergiraf
    mbnvim
    glimpse # get directory into llm
  ];
}
