{
  pkgs,
  ...
}:
{
  home.file.git-open = {
    enable = true;
    executable = true;
    source = ./git-open;
    target = ".local/bin/git-open";
  };
  home.file.git-claude-commit = {
    enable = true;
    executable = true;
    source = ./git-claude-commit;
    target = ".local/bin/git-claude-commit";
  };
  home.file.git-delete-branches = {
    enable = true;
    executable = true;
    source = ./git-delete-branches;
    target = ".local/bin/git-delete-branches";
  };
  home.file.git-new-worktree = {
    enable = true;
    executable = true;
    source = ./git-new-worktree;
    target = ".local/bin/git-new-worktree";
  };
  programs.git = {
    enable = true;
  };

  programs.git.settings = {
    user.email = "mbarneyme@gmail.com";
    user.name = "Michael Barney, Jr";
    user.signingkey = "0383630977773772";
    commit.gpgsign = true;
    alias = {
      ls = "log --graph --abbrev-commit --color --pretty=format:'%C(yellow)%h%Creset -%Cred%d%Creset %s %Cgreen(%cr) %C(blue)[%an]%Creset'";
    };
    difftastic = {
      enable = true;
    };
    "credential \"https://github.com\"" = {
      helper = "!${pkgs.gh}/bin/gh auth git-credential";
    };
    "credential \"https://gist.github.com\"" = {
      helper = "!${pkgs.gh}/bin/gh auth git-credential";
    };
    core = {
      editor = "nvim";
    };
    init = {
      defaultBranch = "main";
    };
    status = {
      showUntrackedFiles = "all";
    };
    merge = {
      conflictstyle = "diff3";
      tool = "nvimdiff";
    };
    merge.mergiraf = {
      name = "mergiraf";
      driver = "mergiraf merge --git %O %A %B -s %S -x %X -y %Y -p %P -l %L";
    };
    diff = {
      tool = "nvimdiff";
    };
    mergetool = {
      keepBackup = false;
    };
    pull = {
      rebase = true;
    };
    fetch = {
      prune = true;
      pruneTabs = true;
      recurseSubmodules = true;
    };
    push = {
      autoSetupRemote = true;
    };
    rerere = {
      enabled = true;
    };
    "protocol \"file\"" = {
      allow = "always";
    };
  };

  programs.git.ignores = [
    ".DS_Store"
    ".nlsp-settings"
    ".cache_ggshield"
    "orb.db"
    ".nvim.lua"
    ".envrc"
    ".direnv"
    ".worktree"
    "*.barneylocal"
    "*.barneylocal.*"
  ];

  programs.git.includes = [
    {
      condition = "gitdir:~/dev/work/trek10/";
      contents = {
        user.email = "mbarney@trek10.com";
        user.name = "Michael Barney";
      };
    }
    {
      condition = "gitdir:~/dev/work/caylent/";
      contents = {
        user.email = "michael.barney@caylent.com";
        user.name = "Michael Barney";
      };
    }
  ];

  programs.git.attributes = [
    "* merge=mergiraf"
  ];
}
