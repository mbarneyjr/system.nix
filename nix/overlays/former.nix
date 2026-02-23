final: prev: {
  former = prev.python3Packages.buildPythonApplication {
    pname = "former";
    version = "0.2.8";
    pyproject = true;

    src = prev.fetchFromGitHub {
      owner = "theserverlessway";
      repo = "former";
      rev = "81883bae18e0830a2d7410c2219c7f50217a8cb7";
      hash = "sha256-j47+RNy9EJurfMbtYJHwW8BYbyg6AftkAuqxSbKAo0g=";
    };

    build-system = [
      prev.python3Packages.setuptools
    ];

    dependencies = with prev.python3Packages; [
      requests
      pyyaml
    ];
  };
}
