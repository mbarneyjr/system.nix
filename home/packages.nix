{
  pkgs,
  unstable,
  mbnvim,
  glimpse,
  ...
}:
{
  home.packages = [
    mbnvim
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
    unstable.awscli2
    unstable.aws-sam-cli
    pkgs.docker
    pkgs.pipx
    unstable.presenterm
    unstable.ggshield
    pkgs.nixfmt-rfc-style
    pkgs.nix-tree
    glimpse # get directory into llm
    pkgs.rainfrog
    pkgs.neofetch
    pkgs.speedtest-cli
    pkgs.yt-dlp
    pkgs.bruno
    pkgs.claude-code
    unstable.aws-sso-util
    unstable.awscurl
    unstable.rain # cfn tools
    unstable.cfn-transform # local sam transform
    unstable.former # cfn snippets cli
    unstable.aws-whoami
  ];
}
