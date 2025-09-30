final: prev: {
  aws-vault = prev.buildGoModule rec {
    pname = "aws-vault";
    version = "7.7.1";

    src = prev.fetchFromGitHub {
      owner = "ByteNess";
      repo = "aws-vault";
      rev = "v${version}";
      hash = "sha256-5a9FgIFwfuronnVkYRq9MgZdSw+dekdnOnumiJv+D+I=";
    };

    vendorHash = "sha256-fcpMCZ0yWhyRZxbcSfWeNsH340y+HeRwW14em/gZ4/E=";

    nativeBuildInputs = [
      prev.installShellFiles
      prev.makeWrapper
    ];

    postInstall = ''
      # make xdg-open overrideable at runtime
      # aws-vault uses https://github.com/skratchdot/open-golang/blob/master/open/open.go to open links
      ${prev.lib.optionalString (
        !prev.stdenv.hostPlatform.isDarwin
      ) "wrapProgram $out/bin/aws-vault --suffix PATH : ${prev.lib.makeBinPath [ prev.xdg-utils ]}"}
      installShellCompletion --cmd aws-vault \
        --bash $src/contrib/completions/bash/aws-vault.bash \
        --fish $src/contrib/completions/fish/aws-vault.fish \
        --zsh $src/contrib/completions/zsh/aws-vault.zsh
    '';

    doCheck = false;

    subPackages = [ "." ];

    # set the version. see: aws-vault's Makefile
    ldflags = [
      "-X main.Version=v${version}"
    ];

    doInstallCheck = true;

    installCheckPhase = ''
      $out/bin/aws-vault --version 2>&1 | grep ${version} > /dev/null
    '';

    meta = with prev.lib; {
      description = "Vault for securely storing and accessing AWS credentials in development environments";
      mainProgram = "aws-vault";
      homepage = "https://github.com/99designs/aws-vault";
      license = licenses.mit;
      maintainers = with maintainers; [ zimbatm ];
    };
  };
}
