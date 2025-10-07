{
  home.file.claude-settings = {
    enable = true;
    target = ".claude/settings.json";
    text = builtins.toJSON {
      includeCoAuthoredBy = false;
      awsAuthRefresh = "aws sso login --profile claude";
      env = {
        AWS_PROFILE = "claude";
        CLAUDE_CODE_USE_BEDROCK = 1;
      };
      statusLine = {
        type = "command";
        command = ./statusline.sh;
        padding = 0;
      };
    };
  };
}
