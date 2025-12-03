final: prev: {
  awscli2 = prev.awscli2.overrideAttrs (old: rec {
    version = "2.32.8";

    src = prev.fetchFromGitHub {
      owner = "aws";
      repo = "aws-cli";
      tag = version;
      hash = "sha256-ZSbCKStBm+P6JrWYktdnQzYU/dQ6HYPAq2S1pB9Cqlo=";
    };
  });
}
