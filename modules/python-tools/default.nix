{ inputs, ... }:
{
  flake.modules.homeManager.pythonTools =
    { pkgs, ... }:
    let
      mkTool =
        { name, executables }:
        let
          workspace = inputs.uv2nix.lib.workspace.loadWorkspace { workspaceRoot = ./${name}; };
          pythonSet =
            (pkgs.callPackage inputs.pyproject-nix.build.packages { python = pkgs.python313; }).overrideScope
              (
                pkgs.lib.composeManyExtensions [
                  inputs.pyproject-build-systems.overlays.default
                  (workspace.mkPyprojectOverlay { sourcePreference = "wheel"; })
                  (final: prev: {
                    git-remote-codecommit = prev.git-remote-codecommit.overrideAttrs (old: {
                      nativeBuildInputs = old.nativeBuildInputs ++ final.resolveBuildSystem { setuptools = [ ]; };
                    });
                  })
                ]
              );
          environment = pythonSet.mkVirtualEnv "${name}-environment" workspace.deps.default;
        in
        pkgs.runCommand name { } ''
          mkdir -p $out/bin
          ${pkgs.lib.concatMapStringsSep "\n" (
            executable: "ln -s ${environment}/bin/${executable} $out/bin/${executable}"
          ) executables}
        '';
    in
    {
      home.packages = map mkTool [
        {
          name = "aws-whoami";
          executables = [ "aws-whoami" ];
        }
        {
          name = "awscurl";
          executables = [ "awscurl" ];
        }
        {
          name = "cfn-transform";
          executables = [ "cfn-transform" ];
        }
        {
          name = "cfn-flip";
          executables = [
            "cfn-flip"
            "flip"
          ];
        }
        {
          name = "former";
          executables = [ "former" ];
        }
        {
          name = "aws-sam-cli";
          executables = [ "sam" ];
        }
        {
          name = "git-remote-codecommit";
          executables = [ "git-remote-codecommit" ];
        }
        {
          name = "aws-sso-util";
          executables = [ "aws-sso-util" ];
        }
        {
          name = "yq";
          executables = [
            "yq"
            "xq"
            "tomlq"
          ];
        }
      ];
    };
}
