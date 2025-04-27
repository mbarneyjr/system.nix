({ pkgs, unstable, mbnvim, glimpse, ... }: {
  home.stateVersion = "23.11";
  home.packages = [
    pkgs.kitty
    pkgs.coreutils
    pkgs._1password-cli
    unstable.neovim
    pkgs.neofetch
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
    pkgs.docker
    pkgs.aws-sam-cli
    pkgs.pipx
    pkgs.python311Packages.yq
    pkgs.git-remote-codecommit
    pkgs.git-lfs
    pkgs.ggshield
    pkgs.libcxx
    pkgs.darwin.libiconv
    pkgs.libcxxStdenv
    pkgs.swig
    pkgs.nixfmt-rfc-style
    pkgs.terraform
    pkgs.yt-dlp
    pkgs.nix-tree
    pkgs.lighttpd
    pkgs.rainfrog
    # pkgs.pulumi
    # nvim dependencies
    pkgs.nodejs_20
    pkgs.python311Full
    pkgs.go
    pkgs.golangci-lint
    pkgs.cargo
    pkgs.darwin.libiconv
    pkgs.gopls
    pkgs.cmake
    pkgs.gnumake
    # other
    pkgs.swift
    unstable.presenterm
    glimpse
  ];
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    initExtra = builtins.readFile ./zsh/zshrc;
    initExtraFirst = ''
      fpath=(~/.awsume/zsh-autocomplete/ $fpath)
      setopt no_nomatch && source ~/.config/zsh/* > /dev/null 2>&1 || true && setopt nomatch
    '';
    sessionVariables = {
      PATH = "$HOME/.local/bin:$PATH";
      LD_LIBRARY_PATH = "${pkgs.stdenv.cc.cc.lib}/lib:${pkgs.darwin.libiconv}/lib:${pkgs.libcxx}/lib:$LD_LIBRARY_PATH";
      LIBRARY_PATH = "${pkgs.stdenv.cc.cc.lib}/lib:${pkgs.darwin.libiconv}/lib:${pkgs.libcxx}/lib:$LD_LIBRARY_PATH";
    };
    oh-my-zsh = {
      enable = true;
    };
  };
  programs.direnv = {
    package = pkgs.direnv;
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
    config = {
      global = {
        hide_env_diff = true;
        warn_timeout = "0s";
      };
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

  programs.git = import ./git.nix { inherit pkgs; };
  programs.tmux = import ./tmux { inherit pkgs; };
  home.file.git-open = {
    enable = true;
    executable = true;
    source = ./bin/git-open;
    target = ".local/bin/git-open";
  };
  home.file.tmux-new-session = {
    enable = true;
    executable = true;
    source = ./bin/tmux-new-session.sh;
    target = ".local/bin/tmux-new-session.sh";
  };
  home.file.tmux-list-sessions = {
    enable = true;
    executable = true;
    source = ./bin/tmux-list-sessions.sh;
    target = ".local/bin/tmux-list-sessions.sh";
  };
  home.file.tmux-sessionizer = {
    enable = true;
    executable = true;
    source = ./bin/tmux-sessionizer.sh;
    target = ".local/bin/tmux-sessionizer.sh";
  };
  home.file.op-aws-credential-process = {
    enable = true;
    executable = true;
    source = ./bin/op-aws-credential-process.sh;
    target = ".local/bin/op-aws-credential-process.sh";
  };
  home.file.neovim = {
    enable = true;
    recursive = true;
    source = "${mbnvim}";
    target = ".config/nvim";
  };
  home.file.kitty = {
    enable = true;
    source = ./kitty/kitty.conf;
    target = ".config/kitty/kitty.conf";
  };
  home.file.ghostty = {
    enable = true;
    source = ./ghostty/config;
    target = ".config/ghostty/config";
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

  home.file.awsume = {
    enable = true;
    recursive = true;
    source = ./awsume;
    target = ".awsume";
  };
})
