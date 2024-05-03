({ pkgs, unstable, mbnvim, ... }: {
  home.stateVersion = "23.11";
  home.packages = [
    pkgs._1password
    pkgs.neovim
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
    pkgs.alacritty
    pkgs.docker
    pkgs.aws-sam-cli
    pkgs.pipx
    pkgs.python311Packages.yq
    pkgs.git-remote-codecommit
    pkgs.ggshield
    pkgs.libcxxabi
    pkgs.darwin.libiconv
    pkgs.libcxxStdenv
    unstable.terraform
    pkgs.swig
    pkgs.nixpkgs-fmt
    # nvim dependencies
    pkgs.nodejs_20
    pkgs.python311Full
    pkgs.go
    pkgs.cargo
    pkgs.darwin.libiconv
    pkgs.gopls
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
      LD_LIBRARY_PATH = "${pkgs.stdenv.cc.cc.lib}/lib:${pkgs.darwin.libiconv}/lib:${pkgs.libcxxabi}/lib:$LD_LIBRARY_PATH";
      LIBRARY_PATH = "${pkgs.stdenv.cc.cc.lib}/lib:${pkgs.darwin.libiconv}/lib:${pkgs.libcxxabi}/lib:$LD_LIBRARY_PATH";
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
      shell = {
        program = "/bin/zsh";
        args = [ "--login" ];
      };
      font.normal.family = "MesloLGL Nerd Font Mono";
      font.size = 14;
      selection.save_to_clipboard = true;
      env = {
        TERM = "xterm-256color";
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

  programs.git = import ./git.nix;
  programs.tmux = import ./tmux { inherit pkgs unstable; };
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
    source = ./awsume/config.yaml;
    target = ".awsume/config.yaml";
  };
  targets.darwin.currentHostDefaults."com.apple.controlcenter".BatteryShowPercentage = true;
  targets.darwin.defaults = {
    "com.apple.symbolichotkeys" = {
      AppleSymbolicHotKeys = {
        # default values
        "7" = { enabled = true; value = { type = "standard"; parameters = [ 65535 120 8650752 ]; }; };
        "8" = { enabled = true; value = { type = "standard"; parameters = [ 65535 99 8650752 ]; }; };
        "9" = { enabled = true; value = { type = "standard"; parameters = [ 65535 118 8650752 ]; }; };
        "10" = { enabled = true; value = { type = "standard"; parameters = [ 65535 96 8650752 ]; }; };
        "11" = { enabled = true; value = { type = "standard"; parameters = [ 65535 97 8650752 ]; }; };
        "12" = { enabled = true; value = { type = "standard"; parameters = [ 65535 122 8650752 ]; }; };
        "13" = { enabled = true; value = { type = "standard"; parameters = [ 65535 98 8650752 ]; }; };
        "15" = { enabled = false; };
        "17" = { enabled = false; };
        "19" = { enabled = false; };
        "21" = { enabled = false; };
        "23" = { enabled = false; };
        "25" = { enabled = false; };
        "26" = { enabled = false; };
        "27" = { enabled = true; value = { type = "standard"; parameters = [ 96 50 1048576 ]; }; };
        "28" = { enabled = true; value = { type = "standard"; parameters = [ 51 20 1179648 ]; }; };
        "29" = { enabled = true; value = { type = "standard"; parameters = [ 51 20 1441792 ]; }; };
        "30" = { enabled = true; value = { type = "standard"; parameters = [ 52 21 1179648 ]; }; };
        "31" = { enabled = true; value = { type = "standard"; parameters = [ 52 21 1441792 ]; }; };
        "32" = { enabled = true; value = { type = "standard"; parameters = [ 65535 126 8650752 ]; }; };
        "33" = { enabled = true; value = { type = "standard"; parameters = [ 65535 125 8650752 ]; }; };
        "34" = { enabled = true; value = { type = "standard"; parameters = [ 65535 126 8781824 ]; }; };
        "35" = { enabled = true; value = { type = "standard"; parameters = [ 65535 125 8781824 ]; }; };
        "36" = { enabled = true; value = { type = "standard"; parameters = [ 65535 103 8388608 ]; }; };
        "37" = { enabled = true; value = { type = "standard"; parameters = [ 65535 103 8519680 ]; }; };
        "52" = { enabled = true; value = { type = "standard"; parameters = [ 100 2 1572864 ]; }; };
        "53" = { enabled = true; value = { type = "standard"; parameters = [ 65535 107 8388608 ]; }; };
        "54" = { enabled = true; value = { type = "standard"; parameters = [ 65535 113 8388608 ]; }; };
        "55" = { enabled = true; value = { type = "standard"; parameters = [ 65535 107 8912896 ]; }; };
        "56" = { enabled = true; value = { type = "standard"; parameters = [ 65535 113 8912896 ]; }; };
        "57" = { enabled = true; value = { type = "standard"; parameters = [ 65535 100 8650752 ]; }; };
        "59" = { enabled = true; value = { type = "standard"; parameters = [ 65535 96 9437184 ]; }; };
        "64" = { enabled = true; value = { type = "standard"; parameters = [ 32 49 1048576 ]; }; };
        "65" = { enabled = true; value = { type = "standard"; parameters = [ 32 49 1572864 ]; }; };
        "118" = { enabled = true; value = { type = "standard"; parameters = [ 65535 18 262144 ]; }; };
        "119" = { enabled = true; value = { type = "standard"; parameters = [ 65535 19 262144 ]; }; };
        "120" = { enabled = true; value = { type = "standard"; parameters = [ 65535 20 262144 ]; }; };
        "121" = { enabled = true; value = { type = "standard"; parameters = [ 65535 21 262144 ]; }; };
        "122" = { enabled = true; value = { type = "standard"; parameters = [ 65535 23 262144 ]; }; };
        "123" = { enabled = true; value = { type = "standard"; parameters = [ 65535 22 262144 ]; }; };
        "124" = { enabled = true; value = { type = "standard"; parameters = [ 65535 26 262144 ]; }; };
        "160" = { enabled = true; value = { type = "standard"; parameters = [ 65535 65535 0 ]; }; };
        "162" = { enabled = true; value = { type = "standard"; parameters = [ 65535 96 9961472 ]; }; };
        "163" = { enabled = true; value = { type = "standard"; parameters = [ 65535 65535 0 ]; }; };
        "175" = { enabled = true; value = { type = "standard"; parameters = [ 65535 65535 0 ]; }; };
        "179" = { enabled = false; };
        "184" = { enabled = true; value = { type = "standard"; parameters = [ 53 23 1179648 ]; }; };
        "190" = { enabled = true; value = { type = "standard"; parameters = [ 113 12 8388608 ]; }; };
        "215" = { enabled = true; value = { type = "standard"; parameters = [ 65535 65535 0 ]; }; };
        "216" = { enabled = true; value = { type = "standard"; parameters = [ 65535 65535 0 ]; }; };
        "217" = { enabled = true; value = { type = "standard"; parameters = [ 65535 65535 0 ]; }; };
        "218" = { enabled = true; value = { type = "standard"; parameters = [ 65535 65535 0 ]; }; };
        "219" = { enabled = true; value = { type = "standard"; parameters = [ 65535 65535 0 ]; }; };
        "222" = { enabled = true; value = { type = "standard"; parameters = [ 65535 65535 0 ]; }; };
        "223" = { enabled = false; };
        "224" = { enabled = false; };
        "225" = { enabled = true; value = { type = "standard"; parameters = [ 65535 65535 0 ]; }; };
        "226" = { enabled = true; value = { type = "standard"; parameters = [ 65535 65535 0 ]; }; };
        "227" = { enabled = true; value = { type = "standard"; parameters = [ 65535 65535 0 ]; }; };
        "228" = { enabled = true; value = { type = "standard"; parameters = [ 65535 65535 0 ]; }; };
        "229" = { enabled = true; value = { type = "standard"; parameters = [ 65535 65535 0 ]; }; };
        "230" = { enabled = false; };
        "231" = { enabled = false; };
        "232" = { enabled = false; };

        # Disable Keyboard -> Input Sources keymaps, we want to be able to control+space in other apps
        "60" = { enabled = false; };
        "61" = { enabled = false; };

        # use control+cmd+H and cmd+control+L to switch between spaces
        "79" = { enabled = true; value = { type = "standard"; parameters = [ 104 4 1572864 ]; }; };
        "80" = { enabled = true; value = { type = "standard"; parameters = [ 104 4 1703936 ]; }; };
        "81" = { enabled = true; value = { type = "standard"; parameters = [ 108 37 1572864 ]; }; };
        "82" = { enabled = true; value = { type = "standard"; parameters = [ 108 37 1703936 ]; }; };
      };
    };
  };
})
