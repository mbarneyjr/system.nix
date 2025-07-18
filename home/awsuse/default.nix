{
  programs.zsh.initContent = ''
    _awsuse_console_services_file=${./services.txt}
    ${builtins.readFile ./shell.sh}
  '';
}
