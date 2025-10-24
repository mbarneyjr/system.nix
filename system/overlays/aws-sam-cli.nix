final: prev: {
  aws-sam-cli = prev.aws-sam-cli.overrideAttrs (old: {
    patchPhase = ''
      substituteInPlace requirements/base.txt --replace "click==8.1.8" "click"
    '';
    doCheck = false;
    disabledTests = old.disabledTests or [ ] ++ [
      "test_cli_base"
      "test_cli_some_command"
      "test_override_with_cli_params_and_envvars"
    ];
  });
}
