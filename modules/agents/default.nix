{ inputs, ... }:
let
  agentConfig = pkgs: rec {
    mbnvim = inputs.mbnvim.packages.${pkgs.stdenv.hostPlatform.system}.default;

    context = ./AGENTS.md;

    skills = {
      nvim-review = builtins.readFile "${mbnvim}/skills/nvim-review/SKILL.md";
      stop-slop = ./skills/stop-slop;
      caveman = ./skills/caveman;
      caveman-commit = ./skills/caveman-commit;
      caveman-review = ./skills/caveman-review;
    };

    mcpServers = {
      review-nvim = {
        command = "${mbnvim}/bin/review-nvim-mcp";
      };
      nixos = {
        command = "${pkgs.uv}/bin/uvx";
        args = [
          "mcp-nixos"
        ];
      };
      aws-mcp = {
        type = "http";
        url = "https://aws-mcp.us-east-1.api.aws/mcp";
      };
    };
  };
in
{
  flake.modules.homeManager.agents =
    { pkgs, ... }:
    let
      cfg = agentConfig pkgs;
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
        inherit (cfg) context skills mcpServers;
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
              "mcp__plugin_claude-code-home-manager_aws-mcp__aws___call_aws"
              "mcp__plugin_claude-code-home-manager_aws-mcp__aws___get_presigned_url"
              "mcp__plugin_claude-code-home-manager_aws-mcp__aws___get_tasks"
              "mcp__plugin_claude-code-home-manager_aws-mcp__aws___run_script"
              "mcp__plugin_claude-code-home-manager_aws-mcp__aws___get_regional_availability"
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
      };

      programs.codex = {
        enable = true;
        inherit (cfg) context skills;
      };
    };

  flake.modules.darwin.agents =
    { pkgs, ... }:
    let
      cfg = agentConfig pkgs;
      tomlFormat = pkgs.formats.toml { };
    in
    {
      environment.etc."codex/managed_config.toml".source = tomlFormat.generate "codex-managed-config" {
        mcp_servers = cfg.mcpServers;
      };
    };
}
