{ inputs, ... }:
{
  flake.modules.homeManager.claude =
    { pkgs, ... }:
    let
      mbnvim = inputs.mbnvim.packages.${pkgs.system}.default;
    in
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
          statusLine = {
            type = "command";
            command = ./statusline.sh;
            padding = 0;
          };
          permissions = {
            allow = [
              "mcp__review_nvim"
              "mcp__aws-mcp__aws___read_documentation"
              "mcp__aws-mcp__aws___search_documentation"
              "mcp__aws-mcp__aws___get_regional_availability"
              "mcp__aws-mcp__aws___get_tasks"
              "mcp__aws-mcp__aws___list_regions"
              "mcp__aws-mcp__aws___recommend"
              "mcp__aws-mcp__aws___suggest_aws_commands"
            ];
          };
          hooks = {
            Notification = [
              {
                hooks = [
                  {
                    type = "command";
                    command = "say '[[volm 0.2]] claude needs input'";
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
          aws-mcp = {
            command = "uvx";
            args = [
              "mcp-proxy-for-aws@latest"
              "https://aws-mcp.us-east-1.api.aws/mcp"
            ];
          };
        };
        skills = {
          nvim-review = builtins.readFile "${mbnvim}/skills/nvim-review/SKILL.md";
          caveman = ./skills/caveman;
          caveman-commit = ./skills/caveman-commit;
          caveman-review = ./skills/caveman-review;
        };
      };
    };
}
