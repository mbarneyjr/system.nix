{ pkgs, config, ... }:
{
  programs.zsh = {
    enable = true;
    dotDir = "${config.xdg.configHome}/zsh";
    enableCompletion = true;
    completionInit = ''
      autoload -Uz compinit
      if [ "$(find ~/.config/zsh/.zcompdump -mtime +1 2>/dev/null)" ]; then
        compinit
      else
        compinit -C
      fi
      source ${pkgs.zsh-fzf-tab}/share/fzf-tab/fzf-tab.plugin.zsh
    '';
    initContent = pkgs.lib.mkMerge [
      (builtins.readFile ./zshrc)
      (pkgs.lib.mkBefore ''
        fpath=(~/.awsume/zsh-autocomplete/ $fpath)
        setopt no_nomatch && source ~/.config/zsh/* > /dev/null 2>&1 || true && setopt nomatch
      '')
    ];
    sessionVariables = {
      PATH = "$HOME/.local/bin:$PATH";
      CLAUDE_CODE_USE_BEDROCK = "1";
      SHELL_SESSIONS_DISABLE = "1";
    };
  };
}
