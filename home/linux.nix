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
    pkgs.git
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
    pkgs.gnumake
    pkgs.nodejs_20
    pkgs.python311Full
    pkgs.go
    pkgs.gopls
    pkgs.cargo
    pkgs.fzf
  ];
  home.file.awsume = {
    enable = true;
    source = ./awsume/config.yaml;
    target = ".awsume/config.yaml";
  };
  home.file.tmux-new-session = {
    enable = true;
    executable = true;
    source = ./bin/tmux-new-session.sh;
    target = ".local/bin/tmux-new-session.sh";
  };
  home.file.tmux-sessionizer = {
    enable = true;
    executable = true;
    source = ./bin/tmux-sessionizer.sh;
    target = ".local/bin/tmux-sessionizer.sh";
  };
  home.file.neovim = {
    enable = true;
    recursive = true;
    source = "${mbnvim}";
    target = ".config/nvim";
  };
  programs.home-manager.enable = true;
  programs.bash = {
    enable = true;
    sessionVariables = {
      PATH = "$HOME/.local/bin:$PATH";
      # LD_LIBRARY_PATH = "${pkgs.stdenv.cc.cc.lib}/lib:${pkgs.libcxxabi}/lib:$LD_LIBRARY_PATH";
      # LIBRARY_PATH = "${pkgs.stdenv.cc.cc.lib}/lib:${pkgs.libcxxabi}/lib:$LD_LIBRARY_PATH";
    };
  };
  programs.zsh = {
    enable = true;
    initExtra = builtins.readFile ./zsh/zshrc;
    sessionVariables = {
      PATH = "$HOME/.local/bin:$PATH";
      # LD_LIBRARY_PATH = "${pkgs.stdenv.cc.cc.lib}/lib:${pkgs.libcxxabi}/lib:$LD_LIBRARY_PATH";
      # LIBRARY_PATH = "${pkgs.stdenv.cc.cc.lib}/lib:${pkgs.libcxxabi}/lib:$LD_LIBRARY_PATH";
    };
    oh-my-zsh = {
      enable = true;
    };
  };

  programs.git = import ./git.nix;
  programs.tmux = import ./tmux { inherit pkgs unstable; };
}
