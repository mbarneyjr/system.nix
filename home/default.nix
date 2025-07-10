{
  pkgs,
  username,
  ...
}:
{
  home.stateVersion = "25.05";
  home.username = username;
  home.homeDirectory = if pkgs.stdenv.isDarwin then "/Users/${username}" else "/home/${username}";
  home.enableNixpkgsReleaseCheck = false;
  imports = [
    ./packages.nix
    ./zsh
    ./direnv
    ./git
    ./tmux
    ./ghostty
    ./awsume
    ./claude
    ./opencode
  ];
}
