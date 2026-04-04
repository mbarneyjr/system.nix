{ ... }:
let
  overlayList = [
    (final: prev: {
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

        pythonImportsCheck = [ ];

        meta = with prev.lib; {
          description = "CLI tool to print out the current AWS identity";
          homepage = "https://github.com/benkehoe/aws-whoami";
          license = licenses.mit;
        };
      };
    })

    (final: prev: {
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
    })

    (final: prev: {
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
    })
    (final: prev: {
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
    })
  ];
in
{
  flake.modules = {
    darwin.overlays = {
      nixpkgs.overlays = overlayList;
      nixpkgs.config.allowUnfree = true;
    };

    homeManager.overlays = {
      nixpkgs.overlays = overlayList;
      nixpkgs.config.allowUnfree = true;
    };
  };
}
