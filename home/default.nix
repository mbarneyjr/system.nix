{
  pkgs,
  username,
  ...
}:
{
  home.stateVersion = "24.11";
  home.username = username;
  home.homeDirectory = if pkgs.stdenv.isDarwin then "/Users/${username}" else "/home/${username}";
  imports = [
    ./packages.nix
    ./zsh
    ./direnv
    ./git
    ./tmux
    ./ghostty
    ./awsume
  ];
}
