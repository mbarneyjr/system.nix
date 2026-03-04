{
  pkgs,
  mbnvim,
  ...
}:
{
  home.packages = [
    (pkgs.writeShellScriptBin "claude-code-bedrock" ''
      export CLAUDE_CODE_USE_BEDROCK=1
      exec ${pkgs.claude-code}/bin/claude "$@"
    '')
  ];
  programs.claude-code = {
    enable = true;
    settings = {
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
      permissions = {
        allow = [
          "mcp__review_nvim"
        ];
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
    mcpServers = {
      "review.nvim" = {
        command = "${mbnvim}/bin/review-nvim-mcp";
      };
    };
    skills = {
      nvim-review = ./skills/nvim-review.md;
    };
  };
}
