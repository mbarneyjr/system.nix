{ inputs, ... }:
{
  flake.modules.homeManager.claude =
    { pkgs, ... }:
    let
      mbnvim = inputs.mbnvim.packages.${pkgs.stdenv.hostPlatform.system}.default;
    in
    {
      home.packages = [
        (pkgs.writeShellScriptBin "claude-bedrock" ''
          export CLAUDE_CODE_USE_BEDROCK=1
          exec ${pkgs.claude-code}/bin/claude "$@"
        '')
      ];
      programs.claude-code = {
        enable = true;
        context = ./CLAUDE.md;
        settings = {
          model = "opusplan";
          includeCoAuthoredBy = false;
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
          nixos = {
            command = "${pkgs.uv}/bin/uvx";
            args = [
              "mcp-nixos"
            ];
          };
          aws-mcp = {
            command = "${pkgs.uv}/bin/uvx";
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
