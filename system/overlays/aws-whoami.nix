final: prev: {
  aws-whoami = prev.python3Packages.buildPythonApplication rec {
    pname = "aws-whoami";
    version = "1.2.0";
    pyproject = true;

    src = prev.fetchPypi {
      pname = "aws-whoami";
      inherit version;
      hash = "sha256-a53jpM9sPFqhGKFzyYfSaRYHAnO2d+98swEGQD+GLRg=";
    };

    nativeBuildInputs = [
      prev.poetry
    ];
    build-system = [
      prev.python3Packages.poetry-core
      prev.python3Packages.findpython
      prev.python3Packages.pbs-installer
      prev.python3Packages.pbs-installer.optional-dependencies.download
      prev.python3Packages.pbs-installer.optional-dependencies.install
      prev.python3Packages.tomlkit
      prev.python3Packages.xattr
      prev.python3Packages.cleo
      prev.python3Packages.shellingham
      prev.python3Packages.fastjsonschema
      prev.python3Packages.dulwich
      prev.python3Packages.virtualenv
      prev.python3Packages.requests-toolbelt
      prev.python3Packages.pkginfo
      prev.python3Packages.trove-classifiers
      prev.python3Packages.keyring
      prev.python3Packages.requests
      prev.python3Packages.cachecontrol
      prev.python3Packages.platformdirs
    ];

    dependencies = with prev.python3Packages; [
      boto3
    ];
  };
}
