({ pkgs, ... }: {
  home.stateVersion = "23.11";
  home.packages = [
    pkgs.neovim
    pkgs.neofetch
    pkgs.ripgrep
    pkgs.jq
    pkgs.fzf
    pkgs.wget
    pkgs.gnupg
    pkgs.ack
    pkgs.awscli2
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
    pkgs.raycast
    pkgs.docker
    pkgs.aws-sam-cli
    pkgs.pipx
    pkgs.python311Packages.yq
    pkgs.git-remote-codecommit
    # nvim dependencies
    pkgs.nodejs_20
    pkgs.python311Full
    pkgs.go
    pkgs.cargo
    pkgs.darwin.libiconv
    pkgs.gopls
    pkgs.clang
    pkgs.cmake
    pkgs.gnumake
    # other
    pkgs.swift
  ];
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    initExtra = builtins.readFile ./zsh/zshrc;
    initExtraFirst = ''
      fpath=(~/.awsume/zsh-autocomplete/ $fpath)
    '';
    sessionVariables = {
      PATH = "$HOME/.local/bin:$PATH";
    };
    oh-my-zsh = {
      enable = true;
    };
  };
  programs.alacritty = {
    enable = true;
    settings = {
      window = {
        decorations = "Full";
        opacity = 0.9;
        blur = true;
        dynamic_padding = true;
      };
      font.normal.family = "MesloLGL Nerd Font Mono";
      font.size = 14;
      selection.save_to_clipboard = true;
    };
  };
  programs.ssh = {
    enable = true;
    includes = [
      "~/.ssh/1password.config"
      "~/.ssh/ssm.config"
    ];
  };
  home.file.onepasswordSshConfig = {
    enable = true;
    target = ".ssh/1password.config";
    source = ./ssh/1password.config;
  };
  home.file.ssmConfig = {
    enable = true;
    target = ".ssh/ssm.config";
    source = ./ssh/ssm.config;
  };

  programs.git = import ./git.nix;
  programs.tmux = import ./tmux { inherit pkgs; };
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
    source = ./nvim;
    target = ".config/nvim";
  };

  home.file.yabairc = {
    enable = true;
    target = ".config/yabai/yabairc";
    executable = true;
    source = ./yabai/yabairc;
  };

  home.file.skhd = {
    enable = true;
    target = ".config/skhd/skhdrc";
    executable = true;
    source = ./skhd/skhdrc;
  };
})
