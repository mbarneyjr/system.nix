{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    initExtra = builtins.readFile ./zshrc;
    initExtraFirst = ''
      fpath=(~/.awsume/zsh-autocomplete/ $fpath)
      setopt no_nomatch && source ~/.config/zsh/* > /dev/null 2>&1 || true && setopt nomatch
    '';
    sessionVariables = {
      PATH = "$HOME/.local/bin:$PATH";
      CLAUDE_CODE_USE_BEDROCK = "1";
    };
    oh-my-zsh = {
      enable = true;
    };
  };
}
