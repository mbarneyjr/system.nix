{
  pkgs,
  ...
}:
{
  home.packages = [
    pkgs.claude-code
    (pkgs.writeShellScriptBin "claude-code-bedrock" ''
      export CLAUDE_CODE_USE_BEDROCK=1
      exec ${pkgs.claude-code}/bin/claude "$@"
    '')
  ];
  home.file.claude-settings = {
    enable = true;
    target = ".claude/settings.json";
    text = builtins.toJSON {
      model = "opus";
      includeCoAuthoredBy = false;
      awsAuthRefresh = builtins.concatStringsSep "; " [
        "rm -rf ~/.aws/cli/cache/* 2>/dev/null"
        "aws sts get-caller-identity --profile claude || aws sso login --profile claude"
      ];
      env = {
        AWS_PROFILE = "claude";
      };
      statusLine = {
        type = "command";
        command = ./statusline.sh;
        padding = 0;
      };
      hooks = {
        Notification = [
          {
            hooks = [
              {
                type = "command";
                command = "say 'claude needs input'";
              }
            ];
          }
        ];
      };
    };
  };
}
