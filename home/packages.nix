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
    pkgs.tree
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
    pkgs.pipx
    pkgs.uv
    pkgs.presenterm
    pkgs.nixpkgs-review
    pkgs.nix-output-monitor
    pkgs.glow
    pkgs.gonzo
    pkgs.trufflehog
    pkgs.aws-vault
    pkgs.okta-aws-cli
    pkgs.hyperfine
    pkgs.nixfmt
    pkgs.nix-tree
    pkgs.rainfrog
    pkgs.neofetch
    pkgs.speedtest-cli
    pkgs._1password-cli
    pkgs.shellcheck
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
