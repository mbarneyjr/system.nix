{ username, pkgs, unstable, mbnvim, ... }:

{
  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };
  home.username = username;
  home.homeDirectory = "/home/${username}";
  home.stateVersion = "23.05";
  home.packages = [
    pkgs.neofetch
    pkgs.neovim
    pkgs.ripgrep
    pkgs.jq
    pkgs.fzf
    pkgs.eza
    pkgs.bat
    pkgs.wget
    pkgs.gnupg
    pkgs.ack
    unstable.awscli2
    pkgs.fd
    pkgs.ffmpeg
    pkgs.fswatch
    pkgs.gh
    pkgs.graphviz
    pkgs.imagemagick
    pkgs.lolcat
    pkgs.pandoc
    pkgs.slides
    pkgs.speedtest-cli
    pkgs.alacritty
    pkgs.docker
    pkgs.aws-sam-cli
    pkgs.pipx
    pkgs.python311Packages.yq
    pkgs.git-remote-codecommit
    pkgs.ggshield
    unstable.yarn-berry
    pkgs.libcxxabi
    pkgs.libcxxStdenv
    pkgs.terraform
    pkgs.swig
    pkgs.nixpkgs-fmt
    # nvim dependencies
    pkgs.nodejs_20
    pkgs.python311Full
    pkgs.go
    pkgs.cargo
    pkgs.gopls
    pkgs.cmake
    pkgs.gnumake
    # other
    pkgs.swift
  ];
  home.file.neovim = {
    enable = true;
    recursive = true;
    source = "${mbnvim}";
    target = ".config/nvim";
  };
  programs.home-manager.enable = true;
}
