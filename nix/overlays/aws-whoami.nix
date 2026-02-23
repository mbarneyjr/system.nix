final: prev: {
  aws-whoami = prev.python3Packages.buildPythonPackage rec {
    pname = "aws-whoami";
    version = "1.2.0";
    format = "setuptools";

    src = prev.fetchPypi {
      pname = "aws-whoami";
      inherit version;
      hash = "sha256-a53jpM9sPFqhGKFzyYfSaRYHAnO2d+98swEGQD+GLRg=";
    };

    propagatedBuildInputs = with prev.python3Packages; [
      boto3
    ];

    # Allow using boto3 directly instead of checking for imports
    pythonImportsCheck = [ ];

    meta = with prev.lib; {
      description = "CLI tool to print out the current AWS identity";
      homepage = "https://github.com/benkehoe/aws-whoami";
      license = licenses.mit;
    };
  };
}
