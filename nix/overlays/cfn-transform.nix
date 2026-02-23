final: prev: {
  cfn-transform = prev.python3Packages.buildPythonApplication rec {
    pname = "cfn-transform";
    version = "1.1.0";
    pyproject = true;

    src = prev.fetchFromGitHub {
      owner = "trek10inc";
      repo = "cfn-transform";
      tag = "v${version}";
      hash = "sha256-3887WCg3qqF0+IPBZvG2K7+TWKYj0MycNSflvaSVuDk=";
    };
    patchPhase = ''
      substituteInPlace setup.py --replace "cfn-lint~=0.83.2" "cfn-lint"
      substituteInPlace setup.py --replace "click==7.1.2" "click"
    '';

    build-system = [
      prev.python3Packages.setuptools
    ];

    dependencies = with prev.python3Packages; [
      cfn-lint
      click
    ];
    doCheck = false;
  };
}
