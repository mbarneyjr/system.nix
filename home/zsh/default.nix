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
    initContent = builtins.readFile ./zshrc;
    sessionVariables = {
      PATH = "$HOME/.local/bin:$PATH";
      CLAUDE_CODE_USE_BEDROCK = "1";
      SHELL_SESSIONS_DISABLE = "1";
    };
  };
}
