{
  programs.zsh.initContent = ''
    _awsuse_console_services_file=${./services.txt}
    ${builtins.readFile ./shell.sh}
  '';
  home.file.awsuse-sso = {
    enable = true;
    executable = true;
    source = ./awsuse-sso;
    target = ".local/bin/awsuse-sso";
  };
}
