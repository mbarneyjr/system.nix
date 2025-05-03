{ pkgs }:

{
  enable = true;
  package = pkgs.gitFull;
  aliases = {
    ls = "log --graph --abbrev-commit --color --pretty=format:'%C(yellow)%h%Creset -%Cred%d%Creset %s %Cgreen(%cr) %C(blue)[%an]%Creset'";
  };
  ignores = [
    ".DS_Store"
    ".nlsp-settings"
    ".cache_ggshield"
    "orb.db"
    ".nvim.lua"
    ".envrc"
    ".direnv/"
    "*.barneylocal"
    "*.barneylocal.*"
  ];
  userEmail = "mbarneyme@gmail.com";
  userName = "Michael Barney, Jr";
  includes = [
    {
      condition = "gitdir:~/dev/work/";
      contents = {
        user.email = "mbarney@trek10.com";
        user.name = "Michael Barney";
      };
    }
  ];
  extraConfig = {
    "credential \"https://github.com\"" = {
      helper = "!${pkgs.gh}/bin/gh auth git-credential";
    };
    "credential \"https://gist.github.com\"" = {
      helper = "!${pkgs.gh}/bin/gh auth git-credential";
    };
    user.signingkey = "0383630977773772";
    commit.gpgsign = true;
    core = {
      editor = "nvim -es";
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
}
