final: prev: {
  awscurl = prev.python3Packages.buildPythonApplication rec {
    pname = "awscurl";
    version = "0.36";
    pyproject = true;

    src = prev.fetchFromGitHub {
      owner = "okigan";
      repo = "awscurl";
      tag = "v${version}";
      hash = "sha256-neE1mV43Np4E+wgUHrdfDQndYTqSnB7inhq52+D5a9g=";
    };

    build-system = [
      prev.python3Packages.setuptools
    ];

    dependencies = with prev.python3Packages; [
      requests
      configargparse
      configparser
      urllib3
      botocore
    ];
  };
}
